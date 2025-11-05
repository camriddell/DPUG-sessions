---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.13.0
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

# When should I *Actually* Refactor my Code?

```{code-cell} ipython3
print("Let's Refactor!")
```

## Notebooks vs Scripts

notebooks: prototyping and very interactive
- bind output directly input and view it

scripts: need to run as long process; or run many jobs

refactoring notebooks → scripts
- make more shared reuse that lives in the notebook
- generalizing across other similar datasets

## Refactoring

1. written some code
2. thats confusing, it could faster, any change in input
3. typically this results in an increase in abstraction

## Do you *really* need to refactor that?

**Your time is your currency, more often than not it is better spent performing research**

## When Does Code Repetition Matter?

Some common guidance for writing code
- DRY: Don’t Repeat Yourself
- WET: Write Everything Twice

```{code-cell} ipython3
from pathlib import Path
from csv import DictWriter
from random import Random

rnd = Random(0)

data_dir = Path('data')
data_dir.mkdir(exist_ok=True)

with open(data_dir / '2025-11-02_data.csv', 'w') as f:
    writer = DictWriter(f, fieldnames=["ENTITY", "VALUE"])
    writer.writeheader()
    for _ in range(3):
        writer.writerow({"ENTITY": rnd.choice(["A", "B"]), "VALUE": round(rnd.uniform(0, 10), 3)})
    writer.writerow({"ENTITY": "A", "VALUE": 9999})
    for _ in range(20):
        writer.writerow({"ENTITY": rnd.choice(["A", "B"]), "VALUE": round(rnd.uniform(0, 10), 3)})

with open(data_dir / '2025-11-03_data.csv', 'w') as f:
    writer = DictWriter(f, fieldnames=["entity", "value"])
    writer.writeheader()
    for _ in range(40):
        writer.writerow({"entity": rnd.choice(["A", "B", "C"]), "value": round(rnd.uniform(0, 10), 3)})
    writer.writerow({"entity": "-", "value": 'nan'})
    for _ in range(20):
        writer.writerow({"entity": rnd.choice(["A", "B"]), "value": round(rnd.uniform(0, 10), 3)})

with open(data_dir / '2025-11-04_data.csv', 'w') as f:
    writer = DictWriter(f, fieldnames=["entity", "value"])
    writer.writeheader()
    for _ in range(50):
        writer.writerow({"entity": rnd.choice(["A", "B"]), "value": int(rnd.uniform(0, 10) * 1000)})

print("done")
```

```zsh
tree data
head -n5 data/*
```

**Calculate the averages per date/entity for these data**

Keep in mind the following generation discontinuities!
- 2025-11-02 was the last day that column names were stored in capitol letters
- 2025-11-02 stores missing data as a value 9999 (which is out of range for that column)

- 2025-11-03 stores missing entities as "-", and missing values as "nan"

- 2025-11-04 millimeters were used instead of meters, so all values are stored as 1000× their original values

```{code-cell} ipython3
from pandas import read_csv, NA, concat

res1 = (
    read_csv('data/2025-11-02_data.csv')
    .rename(columns=str.lower)
    .replace({'value': {9999: NA}})
    .groupby('entity')['value'].mean()
)

res2 = (
    read_csv('data/2025-11-03_data.csv')
    .replace({'entity': {'-': NA}, 'value': {"nan": NA}})
    .groupby('entity')['value'].mean()
)
print(res2)

res3 = (
    read_csv('data/2025-11-04_data.csv')
    .assign(value=lambda d: d['value'] / 1_000)
    .groupby('entity')['value'].mean()
)
print(res3)
```

```{code-cell} ipython3
from pandas import read_csv, NA, concat

def preprocess(df):
    result = (
        df.rename(columns=str.lower)
        .replace({'value': {9999: NA, 'nan': NA}, 'entity': {'-': NA}})
    )
    return result

dfs = [
    read_csv('data/2025-11-02_data.csv'),
    read_csv('data/2025-11-03_data.csv'),
    read_csv('data/2025-11-04_data.csv').assign(value=lambda d: d['value'] / 1_000),
]

# feed in to the uniform process step
# contcat(dfs)
results = [preprocess(df) for df in dfs]
```

- Intentional vs incidental repetition.
- Identify steps that can be carried out regardless of the context.

## What do Your Data Structures Suggest?

list vs tuple

```{code-cell} ipython3
elems = ['a', 'b', 'c'] #   mutable
elems = ('a', 'b', 'c') # immutable

elems = ('Cameron', 30, '6\"3\'', 'brown') # one thing
elems = ['a', 'b', 'c'] #   a collection of similar things
```

dict vs list[tuple]

```{code-cell} ipython3
elems = { 'a': 1,   'b': 2,   'c': 3 }

elems['a'] # key based accession
for k, v in elems.items(): # iterate over
    print(k, v)



elems = [('a', 1), ('b', 2), ('c', 3)]
for k, v in elems:
    print(k, v ** 2)
# elems[1][0]



```

## Typing is Important for How You Think

Its not just for mypy, it shapes how we think about and write code.

```{code-cell} ipython3
from numpy import array, mean, var, sqrt
from scipy.stats import t

from dataclasses import dataclass
@dataclass
class Result:
    t_stat: float
    pvalue: float
    dof   : float

def my_ttest(a, b):
    mean_a, mean_b = mean(a), mean(b)
    var_a, var_b = var(a, ddof=1), var(b, ddof=1)

    pooled_se = sqrt((var_a + var_b) / 2)
    t_stat = (
        (mean_a - mean_b) / (pooled_se * sqrt(2 / len(a)))
    )

    dof = len(a) + len(b) - 2
    p_value = 2 * t.sf(abs(t_stat), dof)
    return Result(float(t_stat), float(p_value), int(dof))


control   = array([1.1, 0.9, 1.0, 1.2, 1.1])
treatment = array([1.5, 1.7, 1.6, 1.8, 1.6])
result = my_ttest(control, treatment)
print(result)

print(result.t_stat)
```

For function return types, homogeneity > heterogeneity

```{code-cell} ipython3
def fizzbuzz(value: int) -> list[int | str]:
    results = []
    for i in range(value+1):
        if i == 0:
            results.append(i)
        elif i % 3 == 0 and i % 5 == 0:
            results.append('Fizz Buzz')
        elif i % 3 == 0:
            results.append('Fizz')
        elif i % 5 == 0:
            results.append('Buzz')
        else:
            results.append(i)
    return results

for msg in fizzbuzz(15):
    if isinstance(msg, str):
        print(msg.upper())
```

The current formulation is difficult to work with, if we want to uppercase
the messages that are emitted then we will need to perform an `isinstance`
check on each element, leading to highly branching and nested code.

That is because our return type is *heterogeneous*

heterogeneity: all values are of different types
→ [1, 'a', 'hello', type(...)]

homogeneity: all values are of the same type
→ [1, 2.3]

Instead of thinking we need to either return an integer or a string...
why not return both?

```{code-cell} ipython3
def fizzbuzz(value: int) -> list[tuple[int, str]]:
    results = []
    for i in range(value+1):
        if i == 0:
            results.append((i, ''))
        elif i % 3 == 0:
            results.append((i, 'Fizz'))
        elif i % 5 == 0:
            results.append((i, 'Buzz'))
        else:
            results.append((i, ''))
    return results

for i, msg in fizzbuzz(15):
    print(i, msg.upper())
```

## Keep External Resources Superficial

External resources are usually out of your control, you do not want
their access buried inside of your code.

```{code-cell} ipython3
from json import dump

config = {"smoothing_factor": 10, "speed": 2, "tolerance": 0.009}
with open("config.json", 'w') as f:
    dump(config, f)
```

```{code-cell} ipython3
# config.json → {"smoothing_factor": 10, "speed": 2, "tolerance": 0.009}
from json import load

class Config:
    def __init__(self, path):
        with open(path, 'r') as f:
            data = load(f)
        self.smoothing = data["smoothing_factor"]
        self.speed = data["speed"]
        self.tolerance = data["tolerance"]

    def __repr__(self):
        return f"{type(self).__name__}(smoothing={self.smoothing}, speed={self.speed}, tolerance={self.tolerance})"

config = Config("config.json")
print(config)
```

This the external resource `config.json` is too deep in the code! What happens if we want to load
a config from another file format (yaml, toml, etc.)?

If we reduce the class initialization function to its simples form (e.g. pass in direct values),
we can reduce it to a dataclass at the cost of some convenience.

```{code-cell} ipython3
# config.json → {"smoothing_factor": 10, "speed": 2, "tolerance": 0.009}
from json import load
from dataclasses import dataclass

@dataclass
class Config:
    smoothing: float
    speed: float
    tolerance: float


# but this is a bit inconvenient
with open("config.json") as f:
    options = load(f)
config = Config(smoothing=options['smoothing_factor'], speed=options['speed'], tolerance=options['tolerance'])
print(config)
```

Thankfully we can add convenience back in via alternative constructors

```{code-cell} ipython3
# config.json → {"smoothing_factor": 10, "speed": 2, "tolerance": 0.009}
from json import load
from dataclasses import dataclass

@dataclass
class Config:
    smoothing: float
    speed: float
    tolerance: float

    @classmethod
    def from_json(cls, path):
        with open("config.json") as f:
            options = load(f)
        return cls(smoothing=options['smoothing_factor'], speed=options['speed'], tolerance=options['tolerance'])

    # Have a yaml file? You can load it in manually using your favorite yaml parser,
    #   then in a future version we can add a `from_yaml` convenience method.

print(Config.from_json('config.json'))
```

```{code-cell} ipython3
# config.json → {"smoothing_factor": 10, "speed": 2, "tolerance": 0.009}
from json import load

class Config:
    def __init__(self, smoothing, speed, tolerance):
        self.smoothing = smoothing
        self.speed = speed
        self.tolerance = tolerance

    def __repr__(self):
        return f"{type(self).__name__}(smoothing={self.smoothing}, speed={self.speed}, tolerance={self.tolerance})"

with open("config.json") as f:
    options = load(f)
config = Config(smoothing=options['smoothing_factor'], speed=options['speed'], tolerance=options['tolerance'])
print(config)
```

## When are Exceptions, exceptional?

```{code-cell} ipython3
from time import sleep

x = 0

## ⓐ
# try:
#     x += 1
# except:
#     pass

## ⓑ
# try:
#     x += 1
# except Exception:
#     pass

## ⓒ
# try:
#     x += 1
# except BaseException:
#     pass
```


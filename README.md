# Talks Given at Davis Python User Group (DPUG)

## Sessions

The session themselves are all powered by [pixi](https://pixi.sh/latest/installation/)
To get started with the code from any session you should be able to

1. Install [pixi](https://pixi.sh/latest/installation/)
2. Clone this repository `git clone https://pixi.sh/latest/installation/`
3. Navigate to the session you wish to run locally
4. pixi run jupyterlab .

And you should see a jupyter lab environment where you can then view/execute
the relevant `.ipynb` file(s) within that session.

### 2025-11-04-refactoring

[notes](sessions/2025-11-04-refactoring/notes.ipynb)

This workshop discusses **when and how to refactor code effectively**. It
contrasts notebooks, which are suited for prototyping and interactive work,
with scripts, which are better for long-running processes or repeated tasks.
The content emphasizes that refactoring should be driven by actual need, such
as reducing confusion, improving performance, or enabling reuse across
datasets, while also noting that time spent researching may often be more
valuable than refactoring.

Practical guidance includes identifying intentional versus incidental
repetition, understanding data structures like lists, tuples, and dictionaries,
and using typing to clarify function behavior. The workshop also covers
managing external resources, such as configuration files, using dataclasses and
convenience constructors to maintain clarity and flexibility. Finally, it
touches on proper handling of exceptions and when they are truly necessary,
encouraging thoughtful design that balances robustness with simplicity.

### 2025-05-06-matplotlib

[notes](sessions/2025-05-06-matplotlib/notes.ipynb)

This workshop introduces **advanced Matplotlib techniques** for creating
precise and customized visualizations. It begins by demonstrating how to draw
arbitrary shapes such as rectangles, circles, and triangles on a chart using
Matplotlib's API, highlighting the flexibility it provides for visual design.
The content also briefly situates Matplotlib in the Python ecosystem, noting
its long history and comparison with tools like Seaborn, Plotly, Altair, and
Polars.

The workshop then moves to a practical data example, generating a synthetic
dataset with multiple groups and trial types, and saving it to a CSV file. It
covers techniques for visualizing this data using Matplotlib’s `subplot_mosaic`
to combine multiple chart types, including line plots with error shading, bar
charts, and density visualizations. Emphasis is placed on customizing
annotations, coordinating multiple axes, and exploring different coordinate
systems, demonstrating how to build rich, interpretable visualizations beyond
simple plotting commands.

### 2021-07-20-exceptions

[notes](sessions/2025-11-04-refactoring/notes.ipynb)

This workshop is designed to help learners understand and work with **Python
exceptions and tracebacks**. It covers the difference between an exception,
which tells you *what* went wrong, and a traceback, which tells you *where* the
error occurred in your code. The material introduces common Python exceptions
such as `SyntaxError`, `TypeError`, `ValueError`, `IndexError`,
`ModuleNotFoundError`, `NameError`, and `AttributeError`, providing
explanations, common causes, and strategies for debugging them.

The workshop also explores **nested tracebacks** and errors arising from
external libraries, showing how to follow execution paths to diagnose problems.
Learners are guided on how to **raise their own exceptions** to enforce correct
usage of functions, and how to handle errors using `try`, `except`, `else`, and
`finally` blocks. Overall, the workshop emphasizes practical skills for
interpreting errors, debugging effectively, and writing robust, error-aware
Python code.


# jupyter-sql-example

Example Jupyter Notebooks demonstrating how to make a connection, query a database, and display the results.

## Introduction

Jupyter Notebooks are a type of executable document consisting of cells. "Cells" can contain a variety of content, such as Markdown, HTML, and even executable code with results.

This repository provides examples of connecting to databases and running queries with Jupyter Notebooks. Notebooks are a great storytelling tool for documenting database queries, schemas, or a particular SQL dialect.

## Notebooks

- [mssql](mssql.ipynb)
- [sqlite](sqlite.ipynb)

## Dependencies

- python3
  - ipython-sql ([docs](https://github.com/catherinedevlin/ipython-sql))
  - Pandas ([docs](https://pandas.pydata.org/docs/reference/index.html))
  - SQLAlchemy ([docs](https://docs.sqlalchemy.org/en/14/index.html), [mssql dialect](https://docs.sqlalchemy.org/en/14/dialects/mssql.html))
  - matplotlib ([docs](https://matplotlib.org/stable/index.html))
- VSCode

## Setup

Example setup with the [Chocolatey](https://chocolatey.org/why-chocolatey) on Windows.

```ps1
# Install Dependencies
choco install vscode -y
choco install python3 -y

# Install pipenv to manage a Python venv
choco install pipenv -y

# Setup a Python Virtual Environment
pipenv install
```

## Configure

Set each Jupyter Notebook to use the Python Virtual environment for this repository.

Set the Kernel (Python Virtual Environment) in each Jupyter Notebook to the Python Virtual Environment created by pipenv. Example kernel name: `jupyter-sql-example-s9YgmqLQ`.

## Magics

`%`-prefixed function calls in Jupyter Notebooks are called magics. [Magics](https://ipython.readthedocs.io/en/stable/interactive/magics.html) are kernel-specific commands that provide functionality outside of Jupyter Notebooks.

Interesting magics built-in to Jupyter Notebooks include:

- `%lsmagic` lists the available magic commands within a notebook.
- `%quickref` prints an overview of magic commands commands.

[ipython-sql](https://github.com/catherinedevlin/ipython-sql) provides the `%sql` and `%%sql` magic functions.

## Troubleshooting

### ModuleNotFoundError: No module named 'sql'

Python dependencies the Pipfile may not be installed. Try running `pipenv install` and then configure each Jupyter Notebook Kernel.

# Public tests for the Assignment 3 of PS 2019
Note: This is a "community" effort, so please contribute by proposing new tests. Differently than previous assignments, Assignment 3 uses the same public tests to test all the submitted tasks.

## Test Definition
Each test comes bundled into a folder. The files inside that folder define the various aspects of the tests. Tests are meant to be executed against all the tasks, since all the tasks must implement exactly the same specifications

The name of the files inside the test folders should be self-explanatory, but you are free to peak inside the files that are already committed to the repo.

In case of doubts, open issues, post to the form, write Dr. Alessio Gambi an email.

## How do I import the public tests in my repo?
The suggested solution (thanks @cansurmeli) is to use `git submodule` to import the public-test repo into your repo, while keeping their management separated. Note that you cannot push to public-tests anyway.

To do import `public-tests` to your project, you can do:

```
cd <YOUR_PRIVATE_REPO>
git submodule add git@github.com:se2p/ps-2019-assignment-03-public-tests.git public-tests
```

This creates a folder called `public-tests` in the root of your project. 
You can pull the changes that we will commit to `public-tests` by running the following commands:

```
cd <YOUR_PRIVATE_REPO>
git submodule update --remote
```

Since `public-tests` is an actual git repo, if you change any of tracked files there, git will complain that there are uncommitted changes. In that case you need to stash them or get rid of them.

## Test Execution

In the repo folder, you'll see a bunch of bash scripts. Those scripts are the ones the automated system will use to execute each and every test on your code when you push something to GitHub (**Not yet in real time!!**)

> Q: How does automated testing work? </br>
> A: The test scripts assume that each program is store in a separate folder (e.g., `task-1`, `task-2`) and comes with an executable `run.sh` file (or possibly a make file). If this is the case, the test scripts feed the content of the `input` file to your program and capture the resulting output and error streams using the following command:
>  `cat input | ./run.sh > output 2> error`. 
> The output file is compared to `expected.output` file to generate a diff. If the diff is not empty, the test fails and the result of `diff` is stored in a file that is reported to you. The content of the `error` file, instead, is not considered by the system, but you can look at that, since it might contain useful debugging information.
> Additionally, a number of assertions are executed to check the validity of the output of your program. Failing assertions generate user friendly messages which are included in the final test report and helps you during debugging.

### Assertions
Assertions are encapsulated into independent (bash) scripts. They are grouped into assertions that apply to all games (`game-assertions`), assertions that apply only to games that the user won, and assertions that apply to games that the user lost, because the assertions check properties that must hold only in one or the other case. You are suggested to you propose more/new assertions: this eases debugging and might results in bonus points.

### Running the tests
You can run all the tests, all the tests that previously failed, or run a single test against all the program or a single program.

#### Running all tests

In order to run all the tests against all the programs use the following command:

```
cd public-tests
./run-tests.sh ./tests <LOCATION_OF_YOUR_PRIVATE_REPO>
```

In order to run all the tests against a single program (e.g., `task-1`) use the following command:

```
cd public-tests
./run-tests.sh ./tests <LOCATION_OF_YOUR_PRIVATE_REPO>/task-1
```


#### Running previously failed tests

In order to run all the tests which previously failed against all programs use the following command:

```
cd public-tests
./run-tests.sh ./tests <LOCATION_OF_YOUR_PRIVATE_REPO> --only-failed
```

In order to run all the tests which previously failed against a single programs use the following command:

```
cd public-tests
./run-tests.sh ./tests <LOCATION_OF_YOUR_PRIVATE_REPO>/task-1 --only-failed
```

#### Running a single test

In order to run a single test (e.g. `test-01`) against all the programs use the following command:

```
cd public-tests
./run-tests.sh ./tests/test-01 <LOCATION_OF_YOUR_PRIVATE_REPO>
```

In order to run a single test (e.g. `test-01`) against a single program (e.g. `task-01`) use the following command:

```
cd public-tests
./run-tests.sh ./tests/test-01 <LOCATION_OF_YOUR_PRIVATE_REPO>/task-1
```
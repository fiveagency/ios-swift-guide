# FIVE iOS Swift guide

This is an official guide for FIVE iOS Swift projects. 

## Contributing
If you want to contribute to this documentation, please follow these steps:

##### 1. Create a new Git branch
Branch name should have a prefix `proposal/` followed by a short description of the proposal, e.g. `proposal/code-style`.

##### 2. Fill out the details
Guide must have it's own folder in the root of the repository. If you can separate one guide into more logical components, you can create subfolders.

Each guide/folder **must** have:
- README.md file - this is the main file which contains all of the guide details. You can find more details on how to style MD files [HERE](https://www.markdownguide.org/basic-syntax/).
- Sample code - this is optional, but you are encouraged to add sample code, if possible.

For example, let's say you want to give an example on how to use 2 libraries for dependency injection. The repository structure should look like this:

    Dependency Injection
        Library 1
            ProjectWithLibrary1
            README.md
        Library 2
            ProjectWithLibrary2
            README.md
        README.md

##### 3. Create a Pull request
When you are satisfied with your proposal, create a pull request with `master` as a base branch. Notify the Five iOS team that a new proposal is ready for review via Slack and/or email.

##### 4. Review period
Review period for each proposal is **one week followed by a live discussion in iOS weekly meeting.** After that, a consensus must be reached and proposal can be merged into master. Please use **squash commit** for more clear history tracking.

Rules for review:
1. Use Github PR interface for comments and discussion.
2. If you do not agree with some part of the proposal, leave a comment and an explanation. You can even use Github suggestion feature to propose a change. Pull request creator should either accept the comment or explain why he thinks his original proposal is better.
3. For each comment in the proposal that cannot be resolved, iOS developers will vote on what should be accepted. Majority wins, with the casting vote belonging to iOS Team Lead if deadlock occurs.
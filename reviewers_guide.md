# Reviewer's guide

This document explains the necessary criteria for a student to pass an
assignment.

## Criteria

The assignment is subjectively valued by each reviewer by the following three
criteria:

1. Correctness
2. Design
3. Style

### Correctness

The **correctness** criteria values if the assignment works as expected and if
all of the sub-assignments in the assignments have been solved.

**What that means:** Each assignment has to work, unless specified otherwise in
the assignment itself. Each requested change has to be implemented, otherwise
the student failed (even if the assignment works). E.g. if it's requested to
run `annotate` and the student did everything except that, it's a fail.

**What that doesn't mean:** The reviewer doesn't have to pull each repository,
run it and try to break it. Do so only if you are unsure if the code works!
The whole application doesn't have to work. Only the part changed in the
assignment must work, everything else can be broken. E.g. the comment create
page after we added the captcha.

### Design

The **design** criteria values the quality of the solution. This is a subjective
impression of the extensibility / DRYness / SOLIDness of the code.

**What that means:** The reviewer can reject a solution with a comment
explaining the problem with the submitted design and how it can be improved.
It's valid to reject working solutions if the reviewer thinks that the design
can be substantially improved.

**What that doesn't mean:** The reviewer can't reject a submission with a
comment along the lines "bad design". Rejections based on design have to have
an explanation, have to point to a possible general better solution and should
be open-ended so that the student can ask more questions if needed. Finally,
bad naming isn't bad design - it's bad style.

BAD: no explanation
```text
Bad design
```

BAD: doesn't point to a general better solution
```text
You could have passed the object to the service
```

BAD: isn't open-ended
```text
Pass the object to the service so we use Dependency Injection
```

GOOD:
```text
You could improve this by passing the object to the service instead of
passing the result of the service to the object. This is in line with the
dependency injection pattern which is usefull when we want to create
services/objects that can change behaviour based on their input.
```

### Style

The **style** criteria values the readability of the code - or how easy it is to
understand.

**What that means:** The reviewer can comment and post warnings on bad styling.
The warning must explain why that style is bad. On gross offences, e.g. using
camel case variables, the reviewer can reject the solution but must provide
an explanation.

Gross offences include everything that goes against the official style guide for
Ruby. Or in a simple sentence - everything that would confuse any other Rubyist.
Everything else constitutes a warning.

Tools like Rubocop may be used by the reviewer.

**What that doesn't mean:** The reviewer can't reject solutions because they
have many warnings in Rubocop. Each rejection and warning has to have an
explanation as to why it's important to follow a certain style. E.g. it's
important to use snake cased variable names as that is the convention in Ruby,
this is important so that you can work with other and that others can read your
code without difficulty. Things like 10 method line limits and cyclomatic
complexity can be explained through bad design suggestions - e.g. This method is
quite large, this usually indicates that it has too much responsibility, can you
perhaps break it's logic down into steps, e.g. `prepare_flour`, `break_eggs`,
`add_yeast`, `kneed` and `bake` and then call those methods inside this method?

## Netiquette

Each comment a reviewer makes must have a suggestive nature
(e.g. `you could do this, that may solve your problem`).

Comment's can't use imperatives (e.g. `do this and that`) - reviewers have to
value the other person's freedom of expression and ideas.

As a reviewer try to separate yourself from perfectionism ideas - for a
beginner it's more valuable to learn how to run than to learn how to run fast.

Empower, don't depress people. Try to be uplifting, open, suggestive. Try to
avoid explicitly stating that something is bad, instead try to show how it can
be improved.

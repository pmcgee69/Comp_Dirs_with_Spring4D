# Comp_Dirs_with_Spring4D
Compare two directories, using features of Spring4D

Function ideas teach us to map and fold functions over data-structures; to zip lists together; and evaluate lazily.

When a friend put forward the idea of comparing directory structure versions, I immediately thought of Zip ... but ZipByValue, not ZipByIndex.

I needed help from Claude to get a start on thinking about the problem. The actual solutions where not valid in Spring4D, but a good starting point. (And I got hung up on TEnumerable vs IEnumerable<T> for a while, trying to create the Select statements). Claude is not the full bottle on Spring4D, I think.

I thought there might need to be monadic operations on Lists of Lists ... but at least in this initial version, it just runs linearly.

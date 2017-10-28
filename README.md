# _For loops_ vs. _apply_ in R
In this post, we'll compare the computational efficiency of **for loops** vs. the **apply** function in R. 

## Background
**for loops** are a way of executing a command again and again, with the value of one or more variables changed each time. Let's say we have data on a bunch of people for food-related spending over one week. (And that yes, some days they spent only $0.11 and they never spent more than $10. Bear with me.) The first four columns of our matrix look like this:

![](https://1.bp.blogspot.com/-k8urW3PwrNo/WWfNHpLzWEI/AAAAAAAABZQ/QT98q-Nq9Z4Hq-yFRpUL-lgVppNEIXX4ACLcBGAs/s1600/spent.png)

 If we want to know the average amount each person spent that week, we can take the mean of every column. If our matrix is called our.matrix, we could type out: 

```r
mean(our.matrix[, 1])
mean(our.matrix[, 2])
mean(our.matrix[, 3])
mean(our.matrix[, 4])
...
```

But a simpler way to do this, especially if you have a lot of columns, would be to iterate through the columns with a for loop, like this:

```r
for(i in 1:ncol(our.matrix)){
    mean(our.matrix[, i])
}
```
Here, the value of **_i_** is being replaced with the number 1, 2, 3, etc. up to the matrix's number of columns. 

Conceptually, this is pretty easy to understand. For loops are straightforward and for many applications, they're an excellent way to get stuff done. (We'll use nested loops in the next section, for example.) But one of the first things a beginning coder might hear about for loops is that as soon as you get the hang of them, it's a good idea to move onto more elegant functions that are simpler and faster. (This [DataCamp intro to loops post](https://www.datacamp.com/community/tutorials/tutorial-on-loops-in-r#gs.DrVUdXM), for example, mentions alternatives in the same sentence it introduces for loops!) One such "elegant" command is called apply. 

```r
apply(our.matrix, 2, mean)
```

The apply command above does the same thing as the two preceding chunks of code, but it's much shorter and considered better practice to use. We're making our final script length shorter and the code above is easier to read. But what about what's going on under the hood? Does your computer find the above command actually faster to compute? Let's find out.

## Methods
At its core, our methods will involve creating a matrix, performing a calculation on every column in the matrix with either a **for loop** or **apply**, and timing how long the process took. We'll then compare the computation times, which will be our measure of efficiency. Before we get started, however, we'll address three additional points:

#### 1. Examine the role of matrix size
If there are differences in computational efficiency between for loops and apply, the differences will be more pronounced for larger matrices. In other words, if you want to know if you or your girlfriend is a better endurance runner, you'll get a more accurate answer if you run a marathon than if you race to that plate of Nachos on the table. (Save yourself an argument about fast-twitch versus slow-twitch muscle and just agree that watching Michael Phelps YouTube videos basically counts as exercise anyway.) So as we pit our competing methods against each other, we want to give them a task that will maximize the difference in their effectiveness.

But the nice thing about coding is that it's often really easy to get a more nuanced answer to our question with just a few more lines of code. So let's ask how the difference in effectiveness between for loops and apply changes with the size of the matrix. Maybe there's effectively no difference until you're dealing with matrices the size of what Facebook knows about your personal life, or maybe there are differences in efficiency right from the start. To look at this, we'll keep the number of columns constant at 1,000 but we'll vary the size of each column from 2 rows to 1,000.

#### 2. Vary how difficult the computation is
Maybe our results will depend on what computation, exactly, we're performing on our matrices. We'll use a simple computation (just finding the mean) and a more complicated one (finding the mean of the six smallest values, which requires sorting and subsetting too).  

#### 3. Minimize the role of chance
At the core of statistics is that there are innumerable random forces swaying the results in any data collection we perform. Maybe that bird preening itself just had an itch and isn't actually exhibiting some complex self recognition. Maybe the person misread the survey question and doesn't actually think the capital of Montana is the sun. One way we address this randomness we can't control for is through replication. We give a survey to lots of people; we look at lots of birds. One sun-lover is probably a mistake, but if everyone in the survey thought the sun was the capital, then we need to sit down and reevaluate how Montana is being portrayed in the media. So in our code, we'll run our simulation 10 times to account for randomness within our computer's processing time.

_[The code to carry out this posts is in this repository. It's called for-loops_v_apply.R.]_

## Results
#### 1. Simple calculation



# Statistical Analysis in R for EmPra SoSe 2025 S1

# --- Part 1: Setup and Introduction (15 minutes) ---
# Welcome to the R session! Today, we'll learn how to transform your raw data
# into meaningful insights using R, a powerful tool for statistical analysis.
# This session connects directly to your research cycle, helping you analyze
# the data you've collected based on your study proposals.

# 1.1 Setting up your RStudio Environment
# RStudio is an Integrated Development Environment (IDE) that makes working with R much easier.
# You'll see four main panes:
#   - Top-Left: Source Editor (where you write and save your R scripts like this one)
#   - Bottom-Left: Console (where R commands are executed and output is displayed)
#   - Top-Right: Environment/History (shows objects/variables you've created, command history)
#   - Bottom-Right: Files/Plots/Packages/Help (for navigating files, viewing plots, managing packages, and getting help)

# 1.2 Working Directory
# The working directory is the folder where R will look for your data files
# and save any output files. It's good practice to keep your data and R script
# in the same folder.
# You can check your current working directory:
getwd()

# To set your working directory (replace "path/to/your/folder" with your actual folder path):
# setwd("C:/Users/YourName/Documents/ResearchPracticum") # Example for Windows
# setwd("~/Documents/ResearchPracticum")                # Example for macOS/Linux (~) refers to your home directory

# A simpler way in RStudio: Session -> Set Working Directory -> Choose Directory...

# 1.3 Installing and Loading Packages
# Packages are collections of functions and data that extend R's capabilities.
# You only need to install a package once on your computer.
# We'll use 'tidyverse' for data manipulation and visualization, and 'psych' for descriptive stats.
# If you haven't installed them, uncomment and run the lines below:
# install.packages("tidyverse")
# install.packages("psych") # Useful for more detailed descriptive statistics

# After installation, you need to load a package into your current R session each time you start RStudio.
library(tidyverse) # Includes dplyr (data manipulation) and ggplot2 (plotting)
library(psych)     # For descriptive statistics

# --- Part 2: Data Import and Initial Exploration (30 minutes) ---
# Now, let's get your data into R!

# 2.1 Creating a Sample Dataset (for demonstration)
# We'll create a small, hypothetical dataset for this session.
# In a real scenario, you would be importing your own data.
# This dataset represents student information, including a group assignment,
# study hours, pre-test scores, and exam scores.
student_data <- data.frame(
  StudentID = 1:20,
  Group = rep(c("Control", "Intervention"), each = 10),
  StudyHours = c(
    8, 7, 9, 6, 8, 7, 10, 6, 9, 8, # Control group study hours
    12, 11, 13, 10, 12, 11, 14, 10, 13, 12 # Intervention group study hours
  ),
  ExamScore = c(
    65, 60, 70, 55, 68, 62, 75, 58, 72, 66, # Control group exam scores
    85, 80, 90, 78, 88, 82, 95, 75, 92, 86  # Intervention group exam scores
  ),
  PreTestScore = c(
    50, 45, 55, 48, 52, 47, 58, 46, 53, 51, # Control group pre-test scores
    52, 48, 57, 50, 54, 49, 60, 47, 55, 53  # Intervention group pre-test scores
  )
)

# 2.2 Importing Your Own Data (Crucial Step for Students!)
# Most of you will have your data in a CSV (Comma Separated Values) file.
# Make sure your CSV file is in your working directory.
# Replace "your_data_file.csv" with the actual name of your file.

# If your data is comma-separated:
# my_research_data <- read.csv("your_data_file.csv")

# If your data uses semicolons (;) as separators (common in some European software):
# my_research_data <- read.csv("your_data_file.csv", sep = ";")

# If your data has headers (column names) in the first row, which is usually the case:
# my_research_data <- read.csv("your_data_file.csv", header = TRUE)

# Using readr (part of tidyverse) is often more robust:
# my_research_data <- read_csv("your_data_file.csv") # Automatically detects separator

# For this session, we will continue using 'student_data' for demonstration.
# If you are using your own data, replace 'student_data' with the name of your loaded data frame.
# For example, if you loaded your data as `my_research_data`, use `my_research_data` in subsequent steps.
current_data <- student_data # For demonstration, we'll use the generated data.

# 2.3 Initial Data Exploration
# Before doing any analysis, it's essential to get a feel for your data.

# View the first few rows of your data:
head(current_data)

# View the entire dataset in a spreadsheet-like viewer:
View(current_data) # Note: 'V' is capitalized

# Get a summary of the structure of your data (data types, number of observations):
str(current_data)

# Check the dimensions (number of rows and columns):
dim(current_data)

# Get column names:
names(current_data)

# --- Part 3: Descriptive Statistics (20 minutes) ---
# Descriptive statistics summarize the main features of a dataset.

# 3.1 Summary of all variables (basic)
summary(current_data)

# 3.2 Specific Descriptive Statistics for Numeric Variables
# Let's look at 'ExamScore' and 'StudyHours'.
mean(current_data$ExamScore)
sd(current_data$ExamScore) # Standard Deviation
median(current_data$ExamScore)
min(current_data$ExamScore)
max(current_data$ExamScore)

# You can also get these for 'StudyHours':
mean(current_data$StudyHours)
sd(current_data$StudyHours)

# What if there are missing values (NA)?
# If you have NAs, functions like mean() will return NA. You need to tell R to remove them:
# mean(current_data$ExamScore, na.rm = TRUE) # na.rm = TRUE means "NA remove = TRUE"

# 3.3 Descriptive Statistics for Categorical Variables
# For 'Group', we can count the occurrences of each category:
table(current_data$Group)

# 3.4 Grouped Descriptive Statistics (using dplyr from tidyverse)
# Often, you want to compare descriptive statistics across different groups.
# For example, what's the average ExamScore for the Control vs. Intervention group?
current_data %>%
  group_by(Group) %>%
  summarise(
    MeanExamScore = mean(ExamScore, na.rm = TRUE),
    SDExamScore = sd(ExamScore, na.rm = TRUE),
    MeanStudyHours = mean(StudyHours, na.rm = TRUE),
    Count = n() # Number of observations in each group
  )

# --- Part 4: Inferential Statistics (30 minutes) ---
# Inferential statistics allow us to make inferences about a population based on a sample.
# We'll demonstrate two common tests: a t-test and a correlation.
# Choose the test that aligns with your research question!

# 4.1 Comparing Two Groups: Independent Samples t-test
# Research Question Example: "Does the intervention affect student exam scores?"
# Hypothesis: Students in the Intervention group will have significantly higher exam scores than the Control group.

# The t.test() function is used for t-tests.
# Formula: dependent_variable ~ independent_variable, data = your_data
t_test_result <- t.test(ExamScore ~ Group, data = current_data)

# View the results of the t-test:
t_test_result

# Interpretation of t-test output:
# - 't': The calculated t-statistic.
# - 'df': Degrees of freedom.
# - 'p-value': This is crucial!
#   - If p < 0.05 (a common threshold), we typically say there's a statistically significant difference.
#     This means it's unlikely we'd see such a difference by chance if there was no true difference.
#   - If p >= 0.05, we do not have enough evidence to claim a significant difference.
# - 'alternative hypothesis': States what the test is looking for (e.g., true difference in means is not equal to 0).
# - '95 percent confidence interval': A range where the true difference between the means is likely to fall.
# - 'sample estimates': The mean for each group.

# 4.2 Relationship Between Two Continuous Variables: Pearson Correlation
# Research Question Example: "Is there a relationship between study hours and exam scores?"
# Hypothesis: More study hours will be positively correlated with higher exam scores.

# The cor.test() function is used for correlation tests.
correlation_result <- cor.test(current_data$StudyHours, current_data$ExamScore, method = "pearson")

# View the results of the correlation test:
correlation_result

# Interpretation of correlation output:
# - 't': The t-statistic for the correlation.
# - 'df': Degrees of freedom.
# - 'p-value': Again, crucial for significance.
#   - If p < 0.05, there's a statistically significant linear relationship.
# - 'alternative hypothesis': States what the test is looking for (e.g., true correlation is not equal to 0).
# - '95 percent confidence interval': A range where the true correlation coefficient is likely to fall.
# - 'sample estimates: cor': This is the Pearson correlation coefficient (r).
#   - 'r' ranges from -1 to +1.
#   - +1: Perfect positive linear relationship.
#   - -1: Perfect negative linear relationship.
#   - 0: No linear relationship.
#   - The closer to +1 or -1, the stronger the relationship.

# --- Part 5: Data Visualization (15 minutes) ---
# Visualizing your data helps you and others understand patterns and results more easily.
# We'll use 'ggplot2' (part of tidyverse) which is very powerful for creating elegant plots.

# 5.1 Bar Plot for Categorical Data (e.g., counts per group)
# While 'table()' gives counts, a bar plot visualizes it.
ggplot(current_data, aes(x = Group)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Number of Students per Group",
       x = "Group",
       y = "Number of Students") +
  theme_minimal()

# 5.2 Box Plot for Comparing Numeric Variable Across Groups
# Excellent for visualizing the distribution and central tendency of a numeric variable
# across different categories (e.g., ExamScore by Group).
ggplot(current_data, aes(x = Group, y = ExamScore, fill = Group)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.6) + # Add individual data points
  labs(title = "Exam Scores by Group",
       x = "Group",
       y = "Exam Score") +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1") # Use a nice color palette

# 5.3 Scatter Plot for Relationship Between Two Numeric Variables
# Ideal for visualizing correlations (e.g., StudyHours vs. ExamScore).
ggplot(current_data, aes(x = StudyHours, y = ExamScore)) +
  geom_point(color = "darkblue", size = 3, alpha = 0.7) + # Add points
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Add a linear regression line
  labs(title = "Relationship Between Study Hours and Exam Scores",
       x = "Study Hours per Week",
       y = "Exam Score (%)") +
  theme_minimal()

# 5.4 Histogram for Distribution of a Single Numeric Variable
# Shows the frequency distribution of a single continuous variable.
ggplot(current_data, aes(x = ExamScore)) +
  geom_histogram(binwidth = 5, fill = "lightgreen", color = "black") +
  labs(title = "Distribution of Exam Scores",
       x = "Exam Score",
       y = "Frequency") +
  theme_minimal()

# --- Part 6: Conclusion and Next Steps (10 minutes) ---

# 6.1 Linking Back to Your Research Cycle
# - What do your descriptive statistics tell you about your sample?
# - What do the inferential test results (p-values, effect sizes) tell you about your hypotheses?
#   - Did you find evidence to support your hypothesis?
#   - If not, what might that mean? (It doesn't mean your study failed, but rather that the effect wasn't detected or isn't there).
# - How do your visualizations help communicate your findings?
# - This analysis forms the "Results" section of your research project.

# 6.2 Reproducibility and Saving Your Work
# - **Save this R script!** (File -> Save As...). This script is your "recipe" for your analysis.
#   Anyone can re-run your analysis exactly as you did by running this script.
# - To save plots:
#   - In RStudio, you can use the 'Export' button in the Plots pane.
#   - Or, use code (e.g., ggsave for ggplot2 plots):
#     ggsave("exam_scores_by_group_boxplot.png", plot = last_plot(), width = 7, height = 5, dpi = 300)
#     (This saves the last plot you generated with ggplot2)

# 6.3 Further Learning and Resources
# - RStudio Cheat Sheets (Google "RStudio cheat sheets" - they are excellent visual summaries!)
# - Online tutorials (e.g., RStudio Education, DataCamp, YouTube channels like "R Programming for Beginners")
# - Stack Overflow (for specific error messages or "how-to" questions)
# - Your course instructors for specific guidance on your projects.

# Congratulations! You've completed a basic statistical analysis workflow in R.
# Keep practicing, and don't be afraid to experiment and make mistakes – that's how you learn!

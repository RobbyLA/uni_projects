This is a group project that utilize big data (at least 10,000 rows of data). For this task, here we use the PySpark in a Linux environment using a Virtual Machine.

The data used in this project is taken from [Kaggle](kaggle.com/datasets/ananaymital/us-used-cars-dataset/data) that contains around 3 million used car sales records from the US.
However, here we have preprocessed the dataset first by removing the rows with missing data to make it smaller. The preprocessed dataset has around 700,000 rows left. The dataset can be accessed using this [link](https://drive.google.com/file/d/10mIjOoIOMjll1IUAKCXHo8sYhk1AxDT5/view?usp=sharing)

The aim of this project was to predict the used car price based on several factors. Moreover, due to the dataset has a large number of columns, we also tried to apply the regularization technique, such as the Ridge and Lasso regression, to also help us pick which factors are actually important.

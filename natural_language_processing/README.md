This is a Natural Language Processing (NLP) project that consists of a document classification and a topic modeling task.

The data used is taken from the popular academic website arXiv.org for articles tagged as computer science content (though some of these are in mathematics or physics categories). This spans 2024-2016.
However, due to the size of the data, please download the dataset from this [link](https://drive.google.com/file/d/1sJqkYPIDQcBkLZk04V53X9hla_Tjo_Tr/view?usp=sharing)

The aim of the classification task is to classify whether the article is about Computer Linguistics or not, whereas the topic modeling task is done by using Gensim.

For the classification task, two type of algorithms were tested, which include a Logistic Regression model and a Recurrent Neural Network (RNN) with the variation of number of documents, feature extraction methods, and type of input (title/abstract).
On the other hand, for the topic modeling task, we only use the Gensim Latent Dirichlet Allocation (LDA) model with the variation of number of documents and whether to use bigrams or not.

Note: Please run the RNN code in the GPU as it will take too long if it is run in the CPU.

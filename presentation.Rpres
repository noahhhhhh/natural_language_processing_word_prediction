SwiftKey - Word Prediction
========================================================
author: Noah Xiao
date: 14 Aug 2015
font-family: 'Helvetica'
autosize: true

Intro
========================================================

<small>This presentation acts as part of the completion requirement of the Coursera John Hopkins Data Science Specialisation Capstone.  </small>

<small>The capstone project is about building a word prediction app with R. The app takes the input of word(s)/sentences, and generates a list of predictions of the next word as output.  </small>

<small>The presentation is separeted as the following sections:</small>  
<small>1. A general introduction to the app.  </small>
<small>2. A detailed intrusction and function of the app.  </small>
<small>3. A description of the algorithm behind the app.  </small>

The App
========================================================

![Intial](presentation-figure/shiny_1.png)
<small>When first loading the app, a very simple page is shown as above.</small>
***
![After](presentation-figure/shiny_2.png)
<small>After typing something in the text box, word predictions and visualisation are shown as above.</small>

Instructions and Functions of the App
========================================================

The app is built on top of Shiny, a web application framework for R. 

* <small>When first loading the page, nothing except the text input box is shown. The user just need to type the word(s)/sentence he/she wants to predict from.  </small>
* <small>Then, 3 sections will show up:</small>
 * <small>A prediction ranking graph: Up to 15 predictions are sorted by probability.</small>
 * <small>A prediction list: Up to 5 top ranked predictions are shown. Once the user pressed the tick button, the corresponding prediction will be attached to the text input box at the top.</small>
 * <small>A wordcloud: Up to 15 predictions are shown in a format of word cloud (same colour indictes same probability)  </small>
* <small>Changing the text input will be reflected immediately in the prediction details.  </small>


The Algorithm
========================================================

The algorigm consists of 3 major parts:  

<small>1. Data Preprocessing (Cleaning the training data)  </small>
<small>1.1 Decode to UTF-8 and Latin words translation to English.  </small>
<small>1.2 Remove indivual numbers (not the numbers attached in a alpha string), punctuations, leading and trailing and multiple spaces, and lowercase the text files.  </small>

<small>2. N-gramming (Building a look-up probability table).  </small>
<small>2.1 Take a sample of the training data.  </small>
<small>2.2 Group the sample corpus into 1-gram, 2-gram, 3-gram, and 4-gram.  </small>
<small>2.3 Construct four look-up probability tables, corresponding to the four grams.  </small>

<small>3. Modelling and Predicting (Applying a simple model)  </small>
<small>Considering about the response time of the web app, a simple back-off model is used. The essense is:  </small>
<small>3.1 start from the a higher gram table, look for the last 3 words of the input, find the corresponding prediction.  </small>
<small>3.2 If found, then sort the predictions by their probabilities.  </small>
<small>3.3 If not, go to the lower gram table.  </small>
<small>3.4 Repeat 3.1 to 3.3, till 1-gram is used.  </small>

<small>Having compared the results with result from a Kneser-Ney model, the accuracy is similar but the simple back-off has a much much better runtime performance.  </small>
<small>Therefore, the simple back-off is being applied.  </small>

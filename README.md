# Spectra-Analysis
## Problem Statement
Prediction of properties and structure from spectra

From several examples of spectra, predict either a) material property or b) structure or composition. Use the feature-engineering or dimensionality reduction techniques in class to extract features from spectra, then apply appropriate regression or classification models. Adhere to best practices such as splitting data into training, validation and testing set, and use these sets to properly train and select the models. The data you are provided with is as follows: -Density of states spectra for 15 elements and 21 alloy systems. The horizontal axes of the spectra are energy and the vertical axes are electronic states available (representing electronic structure). Additionally, the data contains crystal structure label. -Bulk modulus (ie. representing strength) for various compounds. Bulk modulus data is largely available, so this data can be supplemented as necessary -Larger number of elemental DOS, all in same crystal structure. This provides a dataset which can be used to isolate chemistry, and can be supplemented with bulk modulus. -A series of descriptors associated with the elements. This could be used to identify correlations between elemental descriptors and elemental electronic structures. Therefore, this becomes a problem of linking the length scales of electronic structure, chemistry and material property.

These are some potential problems you can explore: 

a. From the spectral data, can you extract property (ie. modulus) from the data using the techniques learned in class? From the calculations, we know both the electronic structure and modulus, and therefore modulus must be represented in the spectra, although how it is represented is not known.

b. From spectra of elements and spectra of compounds, find a relationship between them? If we know the spectra from the elements, can we predict some behavior of the compounds? 

c. You can supplement with data from the Materials Project on energy of compounds. Given energy in crystal structures, can you connect electronic structure and stability?

#References
https://onlinelibrary.wiley.com/doi/pdf/10.1002/sam.10026

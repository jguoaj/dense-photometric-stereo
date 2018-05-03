## Dense Photometric Stereo

### General Idea
This is a project on photometric stereo reconstruction. An object is observed by a fixed camera under different illumination. So we have a dense set of images to start with. The challenge is to infer a 2.5D surface description of the object (that is, a depth model), despite that the captured data are severely contaminated by shadows, highlights, transparency and that the light calibration is inaccurate. 

### Reference Paper
[Dense Photometric Stereo Using a Mirror Sphere and Graph Cut](https://github.com/jguoaj/dense-photometric-stereo/blob/master/dense-photometric-stereo.pdf)

### Methodology
The steps of the project are:

	1: uniform resampling
	2: find denominator image
	3: initial normal estimation
	4: refine normals by MRF graph cut
	5: contruct 3D models

### Results
In this part, we include several examples to demonstrate.

example 02

<img src = "./img/02/1.png" width = "40%" height = "80%"><img src = "./img/02/3.png" width = "40%" height = "80%"><img src = "./img/02/2.png" width = "40%" height = "80%"><img src = "./img/02/4.png" width = "40%" height = "80%">

example 03

<img src = "./img/03/1.png" width = "40%" height = "60%"><img src = "./img/03/2.png" width = "40%" height = "60%"><img src = "./img/03/3.png" width = "40%" height = "60%"><img src = "./img/03/4.png" width = "40%" height = "100%">

example 04

<img src = "./img/04/1.png" width = "40%" height = "60%"><img src = "./img/04/2.png" width = "40%" height = "100%"><img src = "./img/04/3.png" width = "40%" height = "100%"><img src = "./img/04/4.png" width = "40%" height = "100%">

example 05

<img src = "./img/05/1.png" width = "40%" height = "60%"><img src = "./img/05/2.png" width = "40%" height = "40%"><img src = "./img/05/3.png" width = "40%" height = "40%"><img src = "./img/05/4.png" width = "40%" height = "100%">

example 06

<img src = "./img/06/1.png" width = "40%" height = "60%"><img src = "./img/06/2.png" width = "40%" height = "46%"><img src = "./img/06/3.png" width = "40%" height = "46%"><img src = "./img/06/4.png" width = "40%" height = "100%">

example 07

<img src = "./img/07/1.png" width = "40%" height = "60%"><img src = "./img/07/2.png" width = "40%" height = "70%"><img src = "./img/07/3.png" width = "40%" height = "70%"><img src = "./img/07/4.png" width = "40%" height = "100%">

example 08

<img src = "./img/08/1.png" width = "40%" height = "66%"><img src = "./img/08/2.png" width = "40%" height = "70%"><img src = "./img/08/3.png" width = "40%" height = "70%"><img src = "./img/08/4.png" width = "40%" height = "100%">

example 09

<img src = "./img/09/1.png" width = "40%" height = "70%"><img src = "./img/09/2.png" width = "40%" height = "70%"><img src = "./img/09/3.png" width = "40%" height = "70%"><img src = "./img/09/4.png" width = "40%" height = "80%">

example 10

<img src = "./img/10/1.png" width = "40%" height = "60%"><img src = "./img/10/2.png" width = "40%" height = "63%"><img src = "./img/10/3.png" width = "40%" height = "63%"><img src = "./img/10/4.png" width = "40%" height = "100%">

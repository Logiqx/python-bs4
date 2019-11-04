Official Python image with Beautiful Soup 4 and lxml installed.

The pip installation of lxml requires g++ and the development libraries libxml2-dev + libxslt-dev. After the pip installation all of the build dependencies are removed from the image, leaving just the run-time libraries libxml2 and libxslt. The result is a lightweight image of Python 3.8 and Beautiful Soup 4.

Note: Building lxml requires >1GB memory and does not work on tiny machines such as the t3.micro on AWS. To avoid the machine grinding to a standstill the build must be run on a larger instance type such as t3.small.

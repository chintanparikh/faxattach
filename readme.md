# FaxAttach

## Concept

Much to our chagrin, faxing is still a predominant mode of communication in healthcare. As a result, it is very common for providers and hospitals to communicate via fax. In order to better facilitate the transfer of these faxes and documents between hospitals and providers, we designed and built FaxAttach: a service that allows hospitals to print out a cover sheet, fax it to a single number, and have it show up attached to the correct referral.

## Technical Implementation
FaxAttach 'secret sauce' is the 8 character code printed on the cover page that is then OCR'd in the FaxAttach server. This allows the server to determine which referral the attachment belongs to.

FaxAttach was built as a separate application due to lack of OCR libraries available on Heroku. Even if they were available, it likely makes more sense to separate the functionality into its own application.

### External services we rely on
* RingCentral (gives us a number to accept faxes, and then emails faxes to an email)
* PostmarkApp (calls an API endpoint when an email is received)

### Process
1. The fax is received by RingCentral
2. RingCentral emails PostmarkApp with the pdf attached
3. PostmarkApp sends a call to Aidin - ```/inbound``` with a JSON version of the email
4. Aidin decrypts the base64 encoded attachment and creates a new pdf file
5. This pdf file is uploaded to S3
6. The S3 path is sent to FaxAttach ```/process```, along with the local path
7. FaxAttach extracts the code (OCR), and calls ```/register``` in Aidin with the code and local path
8. Aidin creates a new attachment for the referral that corresponds to the code

### EC2 Instance
FaxAttach is running on an EC2 instance and is served through:

* [Nginx](http://nginx.org/)
* [Phusion Passenger](https://www.phusionpassenger.com/)
* [Unicorn](http://unicorn.bogomips.org/)

### Third party libraries

* [Sinatra](http://www.sinatrarb.com/) (Rails was overkill for such a simple app)
* [Capistrano](https://github.com/capistrano/capistrano) (for easy deployment)
* [Docsplit](http://documentcloud.github.io/docsplit/) (deals with the OCR)
* [RestClient](https://github.com/archiloque/rest-client) (easy GET and POST requests)

### Getting everything set up locally
Assuming you've already gotten Ruby, RVM, and Bundler set up, do the following

* ```brew install graphicsmagick imagemagick ghostscript tesseract tesseract-ocr```
* Download and install [pdftk](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
* Download and install [libreoffice](http://www.libreoffice.org/download)

Clone this repository, ```cd``` into it, and run ```bundle install```

After this, you can start FaxAttach by running ```rackup``` inside the FaxAttach directory. Keep in mind you may have to change the paths in ```faxattach.rb``` in Aidin to test locally. You'll want to change the FaxAttach path to ```localhost:9292``` instead of ```faxattach.staging.myaidin.com```

To push changes to staging, make sure you've committed and pushed your changes to github, then run ```cap deploy```

### Testing locally
Once you have the app running with ```rackup``` you now need to make sure it works.

Open up CyberDuck (or something similar), and get a signed url for an example scanned pdf. Go to your terminal, and type
```curl --data "path=URL&local=something.pdf" http://localhost:9292/process```

Replace URL with the signed url you have. Local doesn't matter at this point, it's only important when you're running FaxAttach through the Aidin app.

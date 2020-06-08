# Payconiq webhook SETUP
When working with payconiq there are quite a few moments when webhook callbacks are required. Since when you are working on constipated-koala 
you are most likely working in a localhosted environment 
I've written this short setup so you can still work on it


#### Setup
1. Install and setup ngrok from their [website](https://ngrok.com/download)
1. Run this command in the folder you've installed ngrok `./ngrok http -host-header=koala.rails.local koala.rails.local:3000`
1. You should see something like this:<br>
**Session Status**                online                                            
**Account**                       Nireon (Plan: Free)                               
**Version**                       2.3.35                                            
**Region**                        United States (us)                                
**Web Interface**                 http://127.0.0.1:4040                             
**Session Status**                online                                            
**Account**                       Nireon (Plan: Free)                               
**Version**                       2.3.35                                            
**Region**                        United States (us)                                
**Web Interface**                 http://127.0.0.1:4040                             
**Forwarding**                    ***http://acdecf972fbf.ngrok.io*** -> http://koala.rails.local:3000                             
**Forwarding**                    https://acdecf972fbf.ngrok.io -> http://koala.rails.local:3000        
1. Copy this part `http://acdecf972fbf.ngrok.io` of the response and paste it into [rbenv-vars](/.rbenv-vars) as the PAYCONIQ_CALLBACKURL environment

Enjoy or something!
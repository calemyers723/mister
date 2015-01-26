class Background < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.send_notify_email
        root_url = "http://mister-pompadour-referral.herokuapp.com/"
        image = CGI::escape(root_url + '/assets/refer/logo-fb69ee306dd1e2eb28dd2e5c9e0c103d.jpg');
        title = CGI::escape('Mister Pompadour');
        url = CGI::escape(root_url);
        twitter_message = CGI::escape("#MisterPompadour #looksharpbeconfident Excited for @mistrpompadour new website launch.")
        

        user = User.find_by_email("kyle.perez1985@gmail.com")
        referral_code = CGI::escape(user.referral_code);
        subject = "Welcome Email"
        html_content = '<!DOCTYPE html>
                          <html lang="en">
                          <head>
                            <meta charset="utf-8">
                            <title>Welcome</title>
                          </head>
                          <body style="margin: 0 auto;
                                  width: 940px;
                                  text-align: center;
                                  font-family: Arial;
                                  font-size: 25px;">

                            <div style="margin: 20px 0 0 0;text-align:left; float:left;">
                              <img src="/assets/refer/email_logo.jpg">
                            </div>

                            <div style="font-size: 34px;
                                  margin: 20px 0 0 20px; float:left; color: #16355D;">
                              <p style="margin: 10px 0 0; text-align: left;">
                                Welcome to the <i>Friend Referral Campaign...</i>
                              </p>
                              <p style="font-weight: bold;text-align:left; margin: 5px 0 0;">Let the Sharing Begin!</p>  
                              <hr style="font-size: 15px; width: 790px;" />
                            </div>

                            <div style="clear: both;"></div>
                            <div style="text-align: left;">
                              <p style="margin: 30px 0 0 0; color: #355F91;"><i>The more friends you refer = the more <b>FREE</b> product you earn! <b>Simple</b>.</i></p>
                            </div>

                            <div style="margin: 15px 0 0 0;">
                              <p style="color: #4F81BC;">Your Unique Referral Code</p>
                            </div>
                            <div style="background-color: #F1F0EE; width: 550px; margin: 7px auto; padding: 25px 50px;">
                              <div style="border: 1px solid #D1D0C7; background: #FFF; padding: 10px 0; font-size: 11px;"><%= root_url %>?ref=df2c2abfff</div>
                              <div style="width: 120px; height:37px; margin: 25px auto 0; text-aling: center;">
                                <a href="http://www.facebook.com/sharer.php?u='
        html_content += url
        html_content += '?ref='
        html_content += referral_code
        html_content += '&p[title]='
        html_content += title
        html_content += '&p[images][0]='
        html_content += image
        html_content += '" target="_blank" style="background: url(http://mister-pompadour-referral.herokuapp.com/assets/refer/fb.png); background-size: 27px 27px; width:27px; height: 27px; display: inline-block;"></a>
                          <div style="height: 28px; width: 1px; background: #bab9ba; margin: 0 20px; display: inline-block;"></div>
                          <a href="http://twitter.com/share?url='
        html_content += url
        html_content += '?ref='
        html_content += referral_code
        html_content += '&text='
        html_content += twitter_message
        html_content += ''

        html_content += '" target="_blank" style="background: url(http://mister-pompadour-referral.herokuapp.com/assets/refer/twit.png); background-size: 27px 27px; width:27px; height: 27px; display: inline-block;"></a>
                            </div>  
                          </div>
                          <div style="margin-top: 20px;">
                            <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_1.jpg">
                          </div>

                          <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Each friend can only be referred once so make sure you reach them
                            <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>
                          
                          <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
                            <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
                          <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
                            <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
                          </div>
                          <div style="text-align: left;">
                            <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
                          </div>
                          
                          <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
                            <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
                            <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
                            <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
                          </div>
                        </body>
                        </html>

                    '

        user.send_mandrill_email(subject, html_content)

        # subject = "Congratulations on Your First Friend Referral"
        # html_content = '<!DOCTYPE html>
        #                 <html lang="en">
        #                 <head>
        #                   <meta charset="utf-8">
        #                   <title>Welcome</title>
        #                 </head>

        #                 <body style="margin: 0 auto;
        #                         width: 940px;
        #                         text-align: center;
        #                         font-family: Arial;
        #                         font-size: 25px;">

        #                   <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                   </div>

        #                   <div style="font-size: 34px;
        #                         margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                     <p style="margin: 10px 0 0; text-align: left;">
        #                       Congratulations!
        #                     </p>
        #                     <p style="text-align:left; margin: 5px 0 0; font-weight: bold;"><span style="color: #C00000;">1</span> friend has joined the <i>Friend Referral Campaign</i></p>  
        #                     <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                   </div>

        #                   <div style="clear: both;"></div>
        #                   <div style="text-align: left;">
        #                     <p style="margin: 30px 0 0 0; color: #355F91;">You are off to a great start and <span style="color: #C00000;">1</span> friend has officially joined! Only 4 more <i>friend referrals</i> before you earn a <span style="font-size: 30px; font-weight: bold;">Peppermint Shower Experience Travel Kit.</span></p>
        #                   </div>
        #                   <div style="margin-top: 20px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-1.jpg">
        #                   </div>

        #                   <div style="margin: 15px 0 0 0;">
        #                     <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Each friend can only be referred once so make sure you reach them
        #                     <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>
                          
        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)

        # subject = "Congratulations on 5 Friend Referrals"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">
        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         Congratulations! You are earned the
        #                       </p>
        #                       <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Peppermint Shower Experience Travel Kit</p>  
        #                       <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                     </div>

        #                     <div style="clear: both;"></div>
        #                     <div style="text-align: left;">
        #                       <p style="margin: 30px 0 0 0; color: #355F91;"><span style="color: #C00000;">5</span> friends have offically joined the campaign! You finally reached your first milestone and have unlocked the <i>Peppermint Shower Experience Travel Kit</i>!</p>
        #                     </div>
        #                     <div style="margin-top: 20px; color: #355F91;">
        #                       <div style="float: left; width: 400px; margin: 0 auto;">
        #                         <p><span style="color: #C00000;">5</span> Friends Referred (unlocked)</p>
        #                         <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-1.jpg">  
        #                       </div>
        #                       <div style="float: right; width: 400px; margin: 0 auto;">
        #                         <p><span style="color: #C00000;">10</span> Friends Referred (in progress)</p>
        #                         <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-2.jpg">
        #                       </div>
                              
        #                       <div style="clear: both;"></div>
        #                     </div>

        #                     <div style="margin: 15px 0 0 0;">
        #                       <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Each friend can only be referred once so make sure you reach them
        #                     <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>
                          
        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)

        # subject = "Congratulations on 10 Friend Referrals"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">
        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         Congratulations! You are earned the
        #                       </p>
        #                       <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Styling Product of Your Choice</p>  
        #                       <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                     </div>

        #                     <div style="clear: both;"></div>
        #                     <div style="text-align: left;">
        #                       <p style="margin: 30px 0 0 0; color: #355F91;"><span style="color: #C00000;">10</span> friends have joined the campaign! You finally reached your second milestone and unlocked the <i>Styling Product of Your Choice!</i></p>
        #                     </div>
        #                     <div style="margin-top: 20px; color: #355F91;">
        #                       <div style="float: left; width: 400px; margin: 0 auto;">
        #                         <p><span style="color: #C00000;">10</span> Friends Referred (unlocked)</p>
        #                         <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-2.jpg">  
        #                       </div>
        #                       <div style="float: right; width: 400px; margin: 0 auto;">
        #                         <p><span style="color: #C00000;">25</span> Friends Referred (in progress)</p>
        #                         <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-3.jpg">
        #                       </div>
                              
        #                       <div style="clear: both;"></div>
        #                     </div>

        #                     <div style="margin: 15px 0 0 0;">
        #                       <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Each friend can only be referred once so make sure you reach them
        #                     <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>
                          
        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)

        # subject = "Congratulations on 25 Friend Referrals"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">
        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         Congratulations! You are earned the
        #                       </p>
        #                       <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Mister Pompadour Kit of Your Choice</p>  
        #                       <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                     </div>

        #                     <div style="clear: both;"></div>
        #                     <div style="text-align: left;">
        #                       <p style="margin: 30px 0 0 0; color: #355F91;"><span style="color: #C00000;">25</span> friends have joined the campaign! You finally reached your third milestone and unlocked the <i>Mister Pompadour Kit of Your Choice!</i></p>
        #                     </div>
        #                     <div style="margin-top: 20px; color: #355F91;">
        #                       <div style="float: left; width: 400px; margin: 0 auto;">
        #                         <p><span style="color: #C00000;">25</span> Friends Referred (unlocked)</p>
        #                         <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-3.jpg">  
        #                       </div>
        #                       <div style="float: right; width: 400px; margin: 0 auto;">
        #                         <p><span style="color: #C00000;">50</span> Friends Referred (in progress)</p>
        #                         <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-4.jpg">
        #                       </div>
                              
        #                       <div style="clear: both;"></div>
        #                     </div>

        #                     <div style="margin: 15px 0 0 0;">
        #                       <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Each friend can only be referred once so make sure you reach them
        #                     <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>
                          
        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)

        # subject = "Congratulations on 50 Friend Referrals"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">
        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         Congratulations! You are earned the
        #                       </p>
        #                       <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">$100 Mister Pompadour Gift Certificate</p>  
        #                       <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                     </div>

        #                     <div style="clear: both;"></div>
        #                     <div style="text-align: left;">
        #                       <p style="margin: 30px 0 0 0; color: #355F91;">Extraordinary! <span style="color: #C00000;">50</span> friends have joined the campaign thanks to you! You have reached last and final milestone and unlocked the $100 <i>Mister Pompadour Gift Certificate!</i></p>
        #                     </div>

        #                     <div style="margin-top: 20px; color: #355F91;">
        #                       <p><span style="color: #C00000;">50</span> Friends Referred (unlocked)</p>
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/level-4.jpg">
        #                     </div>

        #                     <div style="margin: 15px 0 0 0;">
        #                       <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Even though you maxed out your reward we still appreciate you help <i><b><span style="font-size: 30px;">spreading the word!</span></b></i></p>
                          
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)

        # subject = "Only 3 days left for the Friend Referral Campaign"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">


        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         '
        # html_content += 'Only 3 days left '
        # html_content += 'for the <i>Friend Referral Campaign...</i>
        #                   </p>
        #                   <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Donot miss out on FREE products!</p>  
        #                   <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                 </div>
        #                 <div style="clear: both;"></div>
        #                 <div style="text-align: left;">
        #                   <p style="margin: 30px 0 0 0; color: #355F91;"><span style="color: #C00000;">'
        # html_content += '5'
        # html_content += '</span> friends have joined the campaign thanks to you! You have already earned the '
        # html_content += 'Peppermint Shower Experience Travel Kit'
        # html_content += '. Only <span style="color: #C00000;">'
        # html_content += '5'
        # html_content += '</span> more until you unlock the '
        # html_content += 'Styling Product of Your Choice'
        # html_content += '...Let the Sharing Continue!</p>
        #                   </div>

        #                   <div style="margin-top: 20px; color: #355F91;">
        #                     <p><span style="color: #C00000;">'
        # html_content += '5'
        # html_content += '</span> Friends Referred (in progress)</p>
        #                   <img src="'
        # html_content += 'http://mister-pompadour-referral.herokuapp.com/assets/refer/level-2.jpg'
        # html_content += '">
        #                   </div>

                          
        #                   <div style="margin: 15px 0 0 0;">
        #                     <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Even friend can only be referred once so make sure you reach them <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
                          
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        
        # user.send_mandrill_email(subject, html_content)

        # subject = "Only 2 days left for the Friend Referral Campaign"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">


        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         '
        # html_content += 'Only 2 days left '
        # html_content += 'for the <i>Friend Referral Campaign...</i>
        #                   </p>
        #                   <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Donot miss out on FREE products!</p>  
        #                   <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                 </div>
        #                 <div style="clear: both;"></div>
        #                 <div style="text-align: left;">
        #                   <p style="margin: 30px 0 0 0; color: #355F91;"><span style="color: #C00000;">'
        # html_content += '5'
        # html_content += '</span> friends have joined the campaign thanks to you! You have already earned the '
        # html_content += 'Peppermint Shower Experience Travel Kit'
        # html_content += '. Only <span style="color: #C00000;">'
        # html_content += '5'
        # html_content += '</span> more until you unlock the '
        # html_content += 'Styling Product of Your Choice'
        # html_content += '...Let the Sharing Continue!</p>
        #                   </div>

        #                   <div style="margin-top: 20px; color: #355F91;">
        #                     <p><span style="color: #C00000;">'
        # html_content += '5'
        # html_content += '</span> Friends Referred (in progress)</p>
        #                   <img src="'
        # html_content += 'http://mister-pompadour-referral.herokuapp.com/assets/refer/level-2.jpg'
        # html_content += '">
        #                   </div>

                          
        #                   <div style="margin: 15px 0 0 0;">
        #                     <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Even friend can only be referred once so make sure you reach them <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
                          
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)

        # subject = "Last Day left for the Friend Referral Campaign"
        # html_content = '<!DOCTYPE html>
        #                   <html lang="en">
        #                   <head>
        #                     <meta charset="utf-8">


        #                     <title>Welcome</title>
        #                   </head>
        #                   <body style="margin: 0 auto;
        #                           width: 940px;
        #                           text-align: center;
        #                           font-family: Arial;
        #                           font-size: 25px;">

        #                     <div style="margin: 20px 0 0 0;text-align:left; float:left;">
        #                       <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_logo.jpg">
        #                     </div>

        #                     <div style="font-size: 34px;
        #                           margin: 20px 0 0 20px; float:left; color: #16355D;">
        #                       <p style="margin: 10px 0 0; text-align: left;">
        #                         '
        # html_content += 'Last Day '
        # html_content += 'for the <i>Friend Referral Campaign...</i>
        #                   </p>
        #                   <p style="text-align:left; margin: 5px 0 0; font-weight: bold;">Donot miss out on FREE products!</p>  
        #                   <hr style="font-size: 15px; width: 790px; color: #4F81BC;" />
        #                 </div>
        #                 <div style="clear: both;"></div>
        #                 <div style="text-align: left;">
        #                   <p style="margin: 30px 0 0 0; color: #355F91;"><span style="color: #C00000;">'
        # html_content += 'XX'
        # html_content += '</span> friends have joined the campaign thanks to you! You have already earned the '
        # html_content += 'Peppermint Shower Experience Travel Kit'
        # html_content += '. Only <span style="color: #C00000;">'
        # html_content += 'YY'
        # html_content += '</span> more until you unlock the '
        # html_content += 'Styling Product of Your Choice'
        # html_content += '...Let the Sharing Continue!</p>
        #                   </div>

        #                   <div style="margin-top: 20px; color: #355F91;">
        #                     <p><span style="color: #C00000;">'
        # html_content += 'XX'
        # html_content += '</span> Friends Referred (in progress)</p>
        #                   <img src="'
        # html_content += 'http://mister-pompadour-referral.herokuapp.com/assets/refer/level-2.jpg'
        # html_content += '">
        #                   </div>

                          
        #                   <div style="margin: 15px 0 0 0;">
        #                     <p style="color: #4F81BC;">'
        # html_content += user.referral_code
        # html_content += '</p>
        #                   </div>
        #                   <div style="margin-top: 5px;">
        #                     <img src="http://mister-pompadour-referral.herokuapp.com/assets/refer/email_2.jpg">
        #                   </div>
                          
        #                   <p style="margin: 30px 0 0 10px; font-size: 40px; font-weight: bold; text-align: left; color: #365F91;">Remember...</p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">Even friend can only be referred once so make sure you reach them <i><b><span style="font-size: 30px;">before others do!</span></b></i></p>

        #                   <p style="margin: 30px 0 0 0; font-size: 20px; text-align: left; color: #365F91;">This Friend Referral Campaign will only be available Feb. 1-8. Then it is 
        #                     <i><b><span style="font-size: 30px;">gone forever!</span></b></i></p>
                          
        #                   <div style="background-color: #233E5F;margin: 40px auto; width: 650px;">
        #                     <p style="padding: 17px 20px;text-font: 35px; color: white;">LOOK SHARP. BE CONFIDENT.</p>
        #                   </div>
        #                   <div style="text-align: left;">
        #                     <p style="font-size: 17px; text-algin: left;"><i>copyright&#0169; 2015 Mister Pompadaur, LLC, All rights reserved.</i></p>
        #                   </div>
                          
        #                   <div style="text-align: left; font-size: 16px; margin-bottom: 50px;">
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUNSUB%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="https://us8.admin.mailchimp.com/templates/*%7CUPDATE_PROFILE%7C*" style="float: left; margin: 0 20px 0 0;">unsubscribe from this list</a>
        #                     <a href="http://www.misterpompadour.com/" style="float: left; margin: 0 20px 0 0;">www.misterpompadour.com</a>    
        #                   </div>
        #                 </body>
        #                 </html>'
        # user.send_mandrill_email(subject, html_content)







        # end_time = AdminUser.first.created_at + 7.days
        # end_time = end_time.to_time.to_i
        # now_time = Time.now.to_time.to_i
        # remain_time = end_time - now_time

        # timestamp_day = 60 * 60 * 24
        # remain_day = remain_time / timestamp_day

        
        # if remain_day <= 3 && remain_day >= 1
        #   puts remain_day
        #   users = User.all
        #   for user in users do
        #     puts user.email

        #     # user.send_remainning_emails remain_day
        #   end
        # end

        
   
    end
end

% User input
source = 'lukashsp0@gmail.com';              %from address (gmail)
destination = 'm.ostrihonovaa@gmail.com';              %to address (any mail service)
myEmailPassword = 'xx';                  %the password to the 'from' account
subj = 'This is the subject line of the email';  % subject line
msg = 'This is the main body of the email.';     % main body of email.
%set up SMTP service for Gmail
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',myEmailPassword);
% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% Send the email
sendmail(destination,subj,msg);
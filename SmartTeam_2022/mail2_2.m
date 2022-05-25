source = 'Vesna.STU.2021@gmail.com';              % email odosielatela
destination = 'peter.bakarac@stuba.com';          % email prijímateľa
myEmailPassword = 'Sklenik2022';                  % heslo od emailovej schránky odosielateľa
subj = 'Problem with Vesna!';                     % Predmet emailu
msg = 'Hi, Vesna has problem  with...';           % správa
%set up SMTP pre Gmail
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',myEmailPassword);
% Gmail server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% samotné poslanie
sendmail(destination,subj,msg);


%% Internet connection 
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail',senderMail);      
setpref('Internet','SMTP_Username',senderMail);             
setpref('Internet','SMTP_Password',senderPassword);

%% java script 
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');  

%% Build message
if flag == 1
    message_intro = 'Good news from Vesna comming.';
elseif flag == -1
    message_intro = 'This is a kind warning that Vesna is having trouble.';
else
    message_intro = 'This is a kind notice from Vesna.';
end

messageBody = sprintf(['Hey admin,\n\n', ...
                       '%s Sending message your way:\n\n',...
                       '------------------------------\n%s\n',...
                       '------------------------------',...
                       '\n\nTime of report: %s\n\n',...
                       'Kind regards\nVesna Alarm Bot'],...
                       message_intro, message, ...
                       datestr(now,'mmmm dd, yyyy HH:MM:SS'));

%% Send Mail
try
    sendmail(recipientMail,'Vesna Alarm Bot',messageBody);
catch ME
    if (strcmp(ME.identifier,'MATLAB:sendmail:SmtpError'))
        msg = 'Wrong email or password.';
        causeException = MException('MATLAB:sendmail:SmtpError',msg);
        ME = addCause(ME,causeException);
    end
    warning(getReport(ME, 'extended', 'hyperlinks', 'on'))
end
    
    
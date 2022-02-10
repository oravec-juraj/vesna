function sendMail(message, flag)
%SENDMAIL Send email message
%
%  SENDMAIL(MESSAGE) sends message specified as string from sender to receiver
%  both specified in .env file in main directory of project.
%  
%  SENDMAIL(MESSAGE, FLAG) specifies also type of message, whether 
%  it is error or notification.
%
arguments
    message string
    flag (1,1) int16 {mustBeNumeric,mustBeReal} = 0
end
%% Read variables from file
env_vars = readvars('../.env','FileType','delimitedtext');

senderMail = env_vars{1};
senderPassword = env_vars{2};
recipientMail = env_vars{3};

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
    
    
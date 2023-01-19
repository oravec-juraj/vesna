
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EMAIL
%
% File for sending error e-mail messages. M-file consists of a function
% that does not provide any output parameter. It requires the ID input
% parameter that is used to identify e-mail based on detection of error
% associated with Vesna control. Email message is displayed in the MATLAB
% Command Window.
%
% List of used functions
%   credentials2  - loads e-mail credentials
%   errors        - checks the type of error that occurred
%
% List of input variables
%   id            - identifier of the emerged e-mail
%
% List of local variables
%   data          - user e-mail credentials
%   destin        - recipient's e-mail address
%   email_times   - container of the latest sent e-mail times
%   fileID        - loaded file ID
%   keySet        - array of e-mail specifications
%   msg           - description of the detected error (e-mail message)
%   password      - sender's password
%   source        - sender's e-mail address
%   spec          - e-mail send attempts
%   subj          - name of the detected error (e-mail subject)
%   valueSet1     - array of e-mail titles
%   valueSet2     - array of e-mail bodies
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function email(id)

% Load Gmail credentials
data = credentials2;

source = data{1};
destin = data{2};
password = data{3};

% Set Gmail SMTP
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',password);

% Gmail server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable', 'true' );
props.setProperty('mail.smtp.socketFactory.port','465');

% Message specifications
fileID = fopen('emails/email_spec.txt','r');
keySet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

% Message titles
fileID = fopen('emails/email_title.txt','r');
valueSet1 = strrep(split(fscanf(fileID,'%s'),";"),'_',' ');
fclose(fileID);

% Message bodies
fileID = fopen('emails/email_body.txt','r');
valueSet2 = strrep(split(fscanf(fileID,'%s'),";"),'_',' ');
fclose(fileID);

subj = containers.Map(keySet,valueSet1);
msg = containers.Map(keySet,valueSet2);

% Error display
fprintf(2,strcat(subj(id),' (',string(datetime('now')),')\n',msg(id),'\n\n'))

% Send notification e-mail
for spec = 1:5
    try
        % Load latest sent e-mail time
        email_times = containers.Map(fieldnames(jsondecode(fileread("emails/email_time.json"))), ...
        struct2cell(jsondecode(fileread("emails/email_time.json"))));

        % Check period of e-mail sending & rewrite latest sent e-mail time
        if datetime(email_times(id))+minutes(10) <= datetime('now')
            email_times(id) = string(datetime('now'));
            fileID = fopen("emails/email_time.json",'w');
            fprintf(fileID,'%s',jsonencode(cell2struct(values(email_times)', ...
                keys(email_times)'),PrettyPrint=true));
            fclose(fileID);
            sendmail(destin,subj(id),msg(id));
            fprintf(strcat('Error notification e-mail was sent to your mail address (', ...
                string(datetime('now')),').\n\n'))
        end
        break
    catch
        pause(5)

        % Terminates after 5 attempts
        if spec == 5
            errors('email',spec);
            break
        end
    end
end

end

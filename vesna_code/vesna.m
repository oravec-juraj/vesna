%% VESNA
%
% Object-oriented MATLAB-based toolbox handling Smart Eco Greenhouse VESNA.
% Read more about the project VESNA at: https://vesna.uiam.sk/
% Read more about the VESNA code at: www.https://github.com/oravec-juraj/vesna

classdef vesna < handle

    %% Properties (data) of VESNA object
    properties
        config
        communication
        data
        mail
        version
    end

    %% Methods (functions) of VESNA object
    methods

        %% Core VESNA object constructor
        %
        % Function VESNA is core constructor building an object of class 'VESNA'.
        function obj = vesna(varargin)

            % Check if configuration JSON-file is available
            try
                data = jsondecode(fileread("vesna_config.json"));
            catch
                error("VESNA: Constructor error: Unable to find the configuration file 'vesna_config.json'!")
            end

            % Load setup from the configuration JSON file
            % Check if the JSON file data names in the first (top) layer
            % match the property names of the VESNA object
            names = fieldnames(data);
            for i = 1:length(names)
                if any(cellfun(@isequal, fieldnames(obj), repmat(names(i), size(fieldnames(obj)))))
                    obj.(names{i}) = data.(names{i});
                else
                    error("VESNA: Constructor error: JSON first layer of data names does not match the properties of the VESNA object.")
                end
            end
            vesna_code_version = ver(obj);
        end

        %% Returns version of VESNA-CODE
        %
        % Function VER returns current version label of VESNA-CODE.
        function vesna_code_version = ver(obj)
            vesna_code_version = '2024-04-24';
            obj.version = vesna_code_version;
        end

        %% Display data of object VESNA
        %
        % Function DISP (overrides) display message of object of class VESNA.
        function disp(obj)

            arguments
                obj (1,1)
            end

            if isempty(obj.communication)
                fprintf("Smart greenhouse VESNA (last update: never)\n\n")
                Values = categorical(["[]";"[]";"[]";"[]";"[]"]);
            else
                fprintf("Smart greenhouse VESNA (last update: " + ...
                    string(obj.communication.lastUpdate) + ")\n\n")
                val = obj.communication;
                Values = categorical([val.url;val.login;val.status; ...
                    val.flag;string(val.established)]);
            end

            Info = categorical(["URL";"Login";"Status";"Flag"; ...
                "Connection established"]);
            disp([Info,Values])
        end


        %% Connect to cloud
        %
        % Function CONNECT connects to the remote (cloud) service.
        %
        % VESNA.connect(URL, login, password)
        % where:
        %   URL      - address of the remote service
        %   LOGIN    - login/ID hash
        %   PASSWORD - password/secret has
        function obj = connect(obj,url,login,password)

            arguments
                obj (1,1)
                url (1,1) {mustBeTextScalar}
                login (1,1) {mustBeTextScalar}
                password (1,1) {mustBeTextScalar}
            end

            % Check number of input arguments
            if (nargin == 4)
                % Set connection options
                headerFields = {'Content-type', ...
                    'application/x-www-form-urlencoded';'charset','UTF-8'};
                Options = weboptions('HeaderFields', headerFields);

                try
                    % Log in to cloud
                    response = webwrite(url,'client_id',login,'client_secret', ...
                        password,'grant_type','client_credentials','audience', ...
                        'https://api2.arduino.cc/iot',Options);

                    % Update connection options
                    headerFields = {'Authorization',['Bearer ', ...
                        response.access_token]};
                    Options = weboptions('HeaderFields',headerFields, ...
                        'ContentType','json','MediaType','auto', ...
                        'Timeout',10);

                    errors.identifier = '200';

                catch error_flag
                    % Connection error
                    errors = error_flag;
                end

                % Set properties
                if contains(errors.identifier,'200')
                    % Connected
                    obj.communication.status = "connected";
                    obj.communication.flag = 1;
                    obj.communication.established = datetime("now");
                    obj.communication.options = Options;
                    if obj.communication.reconnect == 0
                        fprintf('\n<strong>Connected</strong>\n');
                    end

                elseif contains(errors.identifier,'400')
                    % Wrong LOGIN (ID) or wrong PASWORD (SECRET)
                    obj.communication.status = "unauthorized";
                    obj.communication.flag = -1;
                    if obj.communication.reconnect == 0
                        error("VESNA: Connection error: Unauthorized access (login failed)!")
                    end

                else
                    % Wrong URL or connection loss
                    obj.communication.status = "failed";
                    obj.communication.flag = -2;
                    if obj.communication.reconnect == 0
                        error("VESNA: Connection error: Connection failed (check network connection)!")
                    end
                end

                % Update LOGIN, URL, PASSWORD data, RECONNECT status
                obj.communication.reconnect = 0;
                obj.communication.url = url;
                obj.communication.login = login;
                obj.communication.password = password;

            elseif (nargin > 0)
                % Incorrect number of input arguments (not == 4)
                error("VESNA: Connection error: 4 inputs required: object, url, login, password!")
            end
        end


        %% Email notifacions
        %
        % Function EMAIL send e-mail notifications.
        %
        % VESNA.email(email_subject, email_body, email_recipient_1,...,email_recipient_N)
        % where:
        %   email_subject     - subject of e-mail
        %   email_body        - body/text of e-mail
        %   email_recipient_1 - recipient no.1 of e-mail
        %   email_recipient_N - recipient no.N of e-mail
        function obj = email(obj,subject,body,recipient,varargin)

            arguments
                obj (1,1)
                subject (1,1)
                body (1,1)
                recipient (1,1)
            end

            arguments (Repeating)
                varargin
            end

            if ~contains(recipient,"@")
                % Not a valid email address
                error("VESNA: Email error: Not a valid email address!")
            end

            % Parse inputs
            obj.mail.components.recipient = recipient;
            obj.mail.components.subject = subject;
            obj.mail.components.body = body;

            % Check if credentials file exist
            try
                creds = jsondecode(fileread(obj.config.data.creds));
                obj.mail.components.sender = creds.sender;
                obj.mail.components.password = creds.password;
            catch
                error("VESNA: Email error: Unable to find the file '%s'!",obj.config.data.creds)
            end

            % Set credentials
            setpref(obj.mail.setup.prefs.internet, obj.mail.setup.prefs.internet, ...
                obj.mail.components.sender);
            setpref(obj.mail.setup.prefs.internet, obj.mail.setup.prefs.server, ...
                obj.mail.setup.prefs.gmail);
            setpref(obj.mail.setup.prefs.internet, obj.mail.setup.prefs.username, ...
                obj.mail.components.sender);
            setpref(obj.mail.setup.prefs.internet, obj.mail.setup.prefs.password, ...
                obj.mail.components.password);

            % Set connection properties
            props = java.lang.System.getProperties;
            props.setProperty(obj.mail.setup.props.authName, ...
                obj.mail.setup.props.authValue);
            props.setProperty(obj.mail.setup.props.className, ...
                obj.mail.setup.props.classValue);
            props.setProperty(obj.mail.setup.props.portName, ...
                obj.mail.setup.props.portValue);

            % Send e-mail
            sendmail([{recipient} varargin], subject, body);
        end

        %% Download data from cloud
        %
        % Function DOWNLOAD downloads (reads) data from remote (cloud) service.
        %
        % VESNA.download(variable_name_1,...,variable_name_N)
        % where:
        %   variable_name_k - k-th name of data variable
        % Example:
        % VESNA.download("temperature","humidity")
        %
        % VESNA.download([variable_name,sample_rate,date_start,date_finish])
        % where:
        %   variable_name - name of data variable
        %   sample_rate   - sampling time in seconds
        %   date_start    - start of time interval in MATLAB DATETIME format
        %   date_finish   - start of time interval in MATLAB DATETIME format
        % Example:
        % VESNA.download(["temperature",sampleRate,"2023-11-07 10:00:00","2023-11-07 11:00:00"])
        %
        % To download all available data simply use:
        % VESNA.download()
        function [downloaded_value,obj] = download(obj,varargin)

            arguments
                obj (1,1)
            end

            arguments (Repeating)
                varargin
            end

            % Check/ensure connection
            obj = reconnect(obj);

            % Load IDs of data from external file
            ids = jsondecode(fileread(obj.config.data.ids));
            % Extract names of variable into struct
            names = fieldnames(ids.vars_ids);
            % Initialize variable for loaded data
            Data = struct;

            % Download current values of all avaiable data
            if isempty(varargin)
                for i = 1:size(struct2table(ids.vars_ids),2)
                    try
                        obj.communication.options.RequestMethod = "auto";
                        downloaded = webread(strcat(obj.config.cloud.URL2things, ...
                            ids.thing_id,obj.config.cloud.properties,ids.vars_ids.(names{i}).id), ...
                            obj.communication.options);
                        Data.(names{i}).value = downloaded.last_value;
                        Data.(names{i}).time = datetime(replace(downloaded.value_updated_at(1:19),"T"," "), ...
                            'InputFormat','yyyy-MM-dd HH:mm:ss');
                        obj.communication.lastUpdate = datetime("now");
                    catch
                        % Check connection
                        obj = reconnect(obj);
                    end
                end

                % Download selected data
            else
                for i = 1:length(varargin)
                    % Check the number of input arguments
                    if ~any(length([varargin{i}]) == [1,2,4])
                        error("VESNA: Download data: Incorrect number of input arguments (1, 2 or 4 inputs expected)!")
                    end

                    if any(length(varargin{i}) == [2,4])
                        % Check if input has correct DATETIME format
                        try
                            datetime(varargin{i}(3));
                            datetime(varargin{i}(4));
                        catch
                            error("VESNA: Download data: Incorrect input date/time format (use e.g., 2021-07-02 09:45:00)!")
                        end
                        % Check if entered datetime contains text format
                        if sum(isletter(varargin{i}(3))) > 1 || ...
                                sum(isletter(varargin{i}(4))) > 1
                            error("VESNA: Download data: Input date/time cannot contain text characters (use e.g., 2021-07-02 09:45:00)!")
                        end
                    end

                    % Try to downaload data
                    try
                        obj.communication.options.RequestMethod = "auto";
                        url_str = strcat(obj.config.cloud.URL2things, ...
                            ids.thing_id,obj.config.cloud.properties, ...
                            ids.vars_ids.(varargin{i}(1)).id);
                        if length(varargin{i}) == 2 || length(varargin{i}) == 4
                            url_str = strcat(url_str, ...
                                obj.config.cloud.timeseries, ...
                                obj.config.cloud.interval,varargin{i}(2));
                            if length(varargin{i}) == 4

                                % Translate from MATLAB native DATETIME format
                                % into to Arduino Iot Cloud DATETIME format
                                datetime_start = char(varargin{i}(3));
                                datetime_end = char(varargin{i}(4));
                                varargin{i}(3) = [datetime_start(1:10), ...
                                    'T',datetime_start(end-7:end),'Z'];
                                varargin{i}(4) = [datetime_end(1:10), ...
                                    'T',datetime_end(end-7:end),'Z'];

                                url_str = strcat(url_str, ...
                                    obj.config.cloud.start, varargin{i}(3), ...
                                    obj.config.cloud.end, varargin{i}(4));
                            end
                        end
                        downloaded = webread(url_str,obj.communication.options);
                        if length(varargin{i}) == 1
                            Data.(varargin{i}).value = downloaded.last_value;
                            Data.(varargin{i}).time = datetime(replace(downloaded.value_updated_at(1:19),"T"," "), ...
                                'InputFormat','yyyy-MM-dd HH:mm:ss');
                        else
                            if isempty(downloaded.data)
                                Data.(varargin{i}(1)).value = [];
                                Data.(varargin{i}(1)).time = [];
                            else
                                Data.(varargin{i}(1)).value = [downloaded.data.value];
                                Data.(varargin{i}(1)).time = NaT(1,length(downloaded.data));
                                arr = {downloaded.data.time};
                                for j = 1:length(downloaded.data)
                                    Data.(varargin{i}(1)).time(j) = datetime(replace(arr{j}(1:end-1),"T"," "), ...
                                        'InputFormat','yyyy-MM-dd HH:mm:ss');
                                end
                            end
                        end
                        obj.communication.lastUpdate = datetime("now");
                    catch
                        % Check connection
                        obj = reconnect(obj);
                    end
                end
            end
            obj.data = Data;
            downloaded_value = Data;
        end

        %% Uploading data to cloud
        %
        % Function UPLOAD uploads (writes) data to remote (cloud) service.
        %
        % VESNA.upload(variable_name_1,variable_value_1...,variable_name_N,variable_value_N)
        % where:
        %   variable_name_k  - k-th name of data variable
        %   variable_value_k - k-th value of data variable
        % Example:
        % VESNA.upload("fans",74,"lighting",32);
        function obj = upload(obj,varargin)

            arguments
                obj (1,1)
            end

            arguments (Repeating)
                varargin
            end

            % Check/ensure connection
            obj = reconnect(obj);

            % Load IDs of data from external file
            ids = jsondecode(fileread(obj.config.data.ids));
            % Extract names of variable into struct
            names = fieldnames(ids.vars_ids);

            % No input data - nothing to upload
            if isempty(varargin)
                error("VESNA: Upload error: No input data to be upload!")

            elseif mod(length(varargin),2) == 1
                % Variable name/value is missing
                error("VESNA: Upload error: The input data are missing variable name/value!")

                % Upload selected data
            else
                for i = 1:2:length(varargin)

                    if ~xor(~ischar(varargin{i}),~isstring(varargin{i}))
                        % Variable name must be string/char
                        error("VESNA: Upload error: Variable name must be a string!")

                    elseif ~any(strcmp(names,varargin{i}))
                        % Incorrect variable name
                        error("VESNA: Upload error: Incorrect/undefined name of variable!")

                    elseif ~isfloat(varargin{i+1})
                        % Variable value must be float
                        error("VESNA: Upload error: Value of variable must be a float!")

                    else
                        % Try to upload data to cloud
                        try
                            obj.communication.options.RequestMethod = "put";
                            webwrite(strcat(obj.config.cloud.URL2things, ...
                                ids.thing_id,obj.config.cloud.properties, ...
                                ids.vars_ids.(varargin{i}).id,obj.config.cloud.publish), ...
                                struct('value',varargin{i+1}),obj.communication.options);
                            obj.communication.lastUpdate = datetime("now");
                        catch
                            % Check/ensure connection
                            obj = reconnect(obj);
                        end
                    end
                end
            end
        end

        %% Reconnection to Cloud
        %
        % Function RECONNECT check network (Internet) connection and connects if possible.
        function obj = reconnect(obj)

            % Check if the communication was already established
            if obj.communication.status == "none"
                error("VESNA: Connection error: Not connected to cloud. Coonect first!")
            end

            % Load IDs of data from external file
            ids = jsondecode(fileread(obj.config.data.ids));
            % Extract names of variable in struct
            names = fieldnames(ids.vars_ids);
            obj.communication.options.RequestMethod = "auto";

            % Try connection (by downloading some data from cloud)
            try
                webread(strcat(obj.config.cloud.URL2things,ids.thing_id, ...
                    obj.config.cloud.properties,ids.vars_ids.(names{1}).id), ...
                    obj.communication.options).last_value;

            catch
                % Update reconnection status
                obj.communication.reconnect = 1;

                % (Re)connect
                obj = connect(obj,obj.communication.url, ...
                    obj.communication.login,obj.communication.password);

                % Check if reconnection works (by downloading some data from cloud)
                try
                    webread(strcat(obj.config.cloud.URL2things,ids.thing_id, ...
                        obj.config.cloud.properties,ids.vars_ids.(names{1}).id), ...
                        obj.communication.options).last_value;

                catch error_flag2
                    % Failed to connect to cloud
                    error("VESNA: Reconnect error: Could not reconnect to the cloud!")
                end
            end
        end

        %% Display variables
        %
        % Function VARIABLES returns list of variables to be exchanged with the remote cloud service.
        function [list_of_variables] = variables(obj)

            % Load IDs of data from external file
            ids = jsondecode(fileread(obj.config.data.ids));
            % Extract names of variable into struct
            names = fieldnames(ids.vars_ids);

            % Create variables list
            vars_string = '\n  <strong>Available variables of VESNA device:</strong>\n (List of available variables to be exchanged with the remote cloud service)\n\n  Measurements:\n\n';
            vars_string2 = '\n  Actuators:\n\n';
            for i = 1:length(names)
                if double(string(ids.vars_ids.(names{i}).reset)) == 0
                    vars_string2 = [vars_string2, '    ', names{i}, '\n'];
                else
                    vars_string = [vars_string, '    ', names{i}, '\n'];
                end
            end
            vars_string = [vars_string,vars_string2];

            % Return outputs: either return list as a variable or display a list on the screen
            if (nargout == 1)
                % Return outputs as a variable (class:cell-array)
                list_of_variables.actuators = {};
                list_of_variables.measurements = {};
                for i = 1:length(names)
                    if double(string(ids.vars_ids.(names{i}).reset)) == 0
                        list_of_variables.actuators{end+1} = names{i};
                    else
                        list_of_variables.measurements{end+1} = names{i};
                    end
                end
                % list_of_variables = names;
            else
                % Display variables list on the screen
                fprintf([vars_string, '\n\n'])
            end
        end

        %% Terminate control
        %
        % Function TERMINATOR terminates/resets (clears) all values of the actuators on the cloud (sets their value to 0).
        % Note, reset value equal to "Inf" is considered to be an idicator of a non-actuator variable and, hence, such value is not reset.
        function [ terminator_flag ] = terminator(obj)

            % Load IDs of data from external file
            ids = jsondecode(fileread(obj.config.data.ids));
            % Extract names of variable into struct
            names = fieldnames(ids.vars_ids);

            if( nargout == 0 ) % verbose mode
                fprintf("\nVESNA: Terminator initialized:\n");
            end

            try
                number_of_actuators = 0;
                for i = 1:length(names)
                    reset_value{i,1} = double(string(ids.vars_ids.(names{i}).reset));
                    if ( reset_value{i} ~= Inf )
                        obj.upload(names{i}, reset_value{i});
                        number_of_actuators = number_of_actuators + 1;
                    end
                end

                for i = 1:length(names)
                    reset_value{i,1} = double(string(ids.vars_ids.(names{i}).reset));
                    if ( reset_value{i} ~= Inf )
                        test_terminator = obj.download(string(names{i}));

                        if ( test_terminator.(names{i}).value == reset_value{i} )
                            flag(i) = 1; % Correct reset

                            if( nargout == 0 ) % verbose mode
                                fprintf(" - correctly reset value of ""%s"": %.2f (%s)\n", names{i}, reset_value{i}, obj.communication.lastUpdate);
                            end

                        else
                            flag(i) = 0; % Reset failed!

                            if( nargout == 0 ) % verbose mode
                                fprintf(" ! WARNING: detected the non-reset value of ""%s"": %.2f [expected: %.2f] (%s)\n", names{i}, test_terminator.(names{i}).value, reset_value{i}, obj.communication.lastUpdate);
                            end

                        end

                    end
                end

            catch
                flag(i) = 0;

                % Check/ensure connection
                obj = reconnect(obj);

                % Re-run terminator
                terminator(obj);
            end

            if (nargout == 1) % Assign output in case it is required
                % Return outputs as a variable (class:double)
                if ( sum(flag) == number_of_actuators )
                    terminator_flag = 1 ;
                else
                    terminator_flag = 0 ; 
                end
            else
                % Display output message on the screen
                if ( sum(flag) == number_of_actuators )
                    fprintf("\nVESNA: All actuators are terminated!\n\n");
                elseif ( sum(flag) < number_of_actuators ) & ( sum(flag) > 0 )
                    fprintf("\nVESNA: Warning! %d problem(s) detected! \nSome actuators were not terminated!\nUse VESNA function DOWNLOAD to inspect!\n", ( number_of_actuators - sum(flag) ) );
                else
                    fprintf("\nVESNA: Error! Function TERMINATOR returned unexpected FLAG=%d!\n",flag);
                end
            end

        end

    end
end
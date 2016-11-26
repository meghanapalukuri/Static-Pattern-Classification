function [Data,len]=load_speaker_data(Data_type,Speaker,Fname)
fname=cat(2,Fname,Speaker,'\',Data_type);
cd(fname);
files = dir;
for i=3:length(files) % First 2 are . and .. for some reason
    Data1= dlmread(files(i).name, ' ', 1, 0);
    len(i-2)=length(Data1);
    if(i==3)
        Data=Data1;
    else
    Data=vertcat(Data,Data1);
    end
end

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

end
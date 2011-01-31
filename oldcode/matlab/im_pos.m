function []=im_pos(cmd,cmddata)
%IM_POS Write image position and pixel value
%        IM_POS() writes the value of the image corresponding to the
%        current pointer position. The value is written in the window.
%
%        To use it, set the 'ButtonDownFcn' property of the image 
%        to 'im_pos', e.g., 
%            set(findobj(gcf,'type','image'),'ButtonDownFcn','im_pos');
%
%        You can get the value of the array rather than the colormap
%        index by setting the 'UserData' property of the image to
%        the matrix and setting the 'UserData' property of the figure
%        to the magic number 1.17100, e.g., if the image displays 
%        matrix X
%            set(findobj(gcf,'type','image'),'UserData',X);
%            set(gcf,'UserData',1.17100);
%        
%        You can get the colormap index value zero relative (rather than 
%        Matlab's 1 relative, useful for 8 bit images) by setting the 
%        'UserData' property of the figure to the magic number 1.19108,
%        e.g.,
%            set(gcf,'UserData',1.19108);
%        This will also use the 'UserData' of the image if it is 
%        not empty.
%
%        [No Guarantees. M. Lubinski]

%        09/15/93 Written by Mark Lubinski (lubinski@eecs.umich.edu)
%        08/23/95 M.L. Updated to display in window
%        03/14/96 M.L. Updated to check if should subtract 1 in value shown
%        03/10/97 M.L. Added limits to use axes limits
%        03/18/97 M.L. Set neg. numbers to use same number of characters
%        07/23/97 M.L. Updated comments and added useuserdata

% Allow defaults
if nargin<2, cmddata=gcf; end
if nargin<1, cmd='d'; end

% Need to change these if function name changes
str_u='im_pos(''u'',gcf);';  % Callback for window button up
str_m='im_pos(''m'',gcf);';  % Callback for window button motion
magicnum0=1.19108;   % =ascii for 'wl'
magicnumU=1.17100;   % =ascii for 'ud'

% Strategy: 
%  When mouse button is pressed DOWN 
%      1) Create a text uicontrol to display values into (with
%         tag='TMP_TXT').
%      2) Save the current window button up and motion callbacks and the
%         pointer into TMP_TXT's user data  for resetting later
%      3) Set the current window button up and motion callbacks to call
%         this function with appropraite arguments
%      4) Create global array called POINT_IMAGEN where N=figure
%         with image data matrix
%      5) Call this function as if the mouse button moved
%  When mouse button is MOVED
%      1) Get the current position
%      2) If the position corresponds to a point in the image,
%         then display the position and image value at that position
%         (using the global matrix POINT_IMAGEN)
%  When the mouse button is UP (or the pointer is ouside of the image)
%      1) Reset the current window button up and motion callbacks and the
%         pointer from the values saved in TMP_TXT's user data
%      2) Return

% Globalize image data matrix to get values from
fh=gcf;
pi = ['POINT_IMAGE',int2str(fh)];
eval(['global ',pi]);

% Check if button up or not current figure
if (cmddata(1) ~= fh) | (strcmp(cmd,'u'))
  % Button UP or no longer current figure
  % So cleanup, reset and exit
  h=findobj(cmddata(1),'Tag','TMP_TXT');
  if isempty(h)
    TMP_WBU=get(cmddata(1),'WindowButtonU');
    TMP_WBM=get(cmddata(1),'WindowButtonM');
    TMP_P='arrow';
  else
    TMP=get(h,'Userdata');
    TMP_WBU=deblank(TMP(1,:));
    TMP_WBM=deblank(TMP(2,:));
    TMP_P=deblank(TMP(3,:));
    set(h,'visible','off');
  end
  if strcmp(TMP_WBU,str_u)
    set(cmddata(1),'WindowButtonUp','');
  else
    set(cmddata(1),'WindowButtonUp',TMP_WBU);
  end
  if strcmp(TMP_WBM,str_m)
    set(cmddata(1),'WindowButtonMot','');
  else
    set(cmddata(1),'WindowButtonMot',TMP_WBM);
  end
  set(cmddata(1),'pointer',TMP_P);
  % Check if global image values should be retained for speed
  relative0=get(fh,'UserData');
  if isempty(relative0)
    relative0 = 0;
  else
    relative0 = (relative0(1) == magicnum0);
  end
  if ~relative0
    eval([pi '=[];']);   % Clear global data
  end
  return
end


% Check which action
if strcmp(cmd,'m')
  % Button MOTION
  h=findobj(fh,'Tag','TMP_TXT');
  if isempty(h)
    im_pos('u',fh);
    return
  end
  ca=get(fh,'CurrentAxes');
  pos=get(ca,'CurrentPoint');
  pos=round(pos(1,1:2));
  xlim=ceil(get(ca,'Xlim'));
  ylim=ceil(get(ca,'Ylim'));
  if ((pos(1)>=xlim(1)) & (pos(1)<xlim(2)) & ...
 (pos(2)>=ylim(1)) & (pos(2)<ylim(2)))
    % DEBUG
disp(sprintf('%s(%d,%d)',pi,pos(2)-ylim(1)+1,pos(1)-xlim(1)+1));
    val=eval([pi,'(pos(2)-ylim(1)+1,pos(1)-xlim(1)+1)']);
    if fix(val)==val
      fmt='%d';
    elseif (abs(val)<10) & (abs(val)>0.01)
      if val>0
 fmt='%.4f';
      else
 fmt='%.3f';
      end
    elseif val>0
      fmt='%.4e';
    else
      fmt='%.3e';
    end
    s_val=sprintf(fmt,val);
    set(h,'String',sprintf('(%d,%d)=%s',pos(2),pos(1),s_val));
  else
    im_pos('u',fh);
    return
  end
  
elseif strcmp(cmd,'d')
  % Button DOWN
  if isempty(gco), return; end
  if ~strcmp(get(gco,'Type'),'image'), return; end
  TMP_WBU=get(fh,'WindowButtonUp');
  TMP_WBM=get(fh,'WindowButtonMot');
  TMP_P=get(fh,'pointer');
  h=findobj(fh,'Tag','TMP_TXT');
  if isempty(h)
    uicontrol('Units','pix','pos',[0 0 150 20],'Style','text',...
 'String','(x,y)=val','Horiz','left','Backg',[0 0 0],...
 'Foreg',[1 1 1],'Tag','TMP_TXT','Userdata',...
 str2mat(TMP_WBU,TMP_WBM,TMP_P));
  else
    set(h,'Visible','on');
  end
  set(fh,'WindowButtonMot',str_m,'WindowButtonUp',str_u);
  % Check if image value should be userdata or colormap index (zero relative)
  relative0=get(fh,'UserData');
  useuserdata=0;
  if isempty(relative0)
    relative0=0;
  else
    useuserdata = (relative0(1)==magicnumU);
    relative0 = (relative0(1)==magicnum0);
  end
  if (isempty(eval(pi))) & (relative0 | useuserdata)
    eval([pi,'=get(gco,''UserData'');']);
  end
  if (isempty(eval(pi)))
    if relative0
      eval([pi,'=get(gco,''CData'')-1;']);
    else
      eval([pi,'=get(gco,''CData'');']);
    end
  end
  set(fh,'Pointer','crosshair');
  im_pos('m',fh);

end

% END function IM_POS
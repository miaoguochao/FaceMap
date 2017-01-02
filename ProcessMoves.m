function movs = ProcessMoves(frames,handles,j)

% take chosen area
ROI = handles.ROI{j};
rX  = handles.rX{j};
rY  = handles.rY{j};
frames = frames(rX,rY,:);
nX  = length(rX);
nY  = length(rY);
nframes = size(frames,3);

fr = [];
fr = reshape(frames,[],size(frames,3));
if handles.svdmat(j-2,1)
    %%%% compute motion
    fr = diff(fr,1,2);
    fr = abs(fr);
    
    % detect movements as change in pixels which are greater than a
    % user-specified threshold
    sats = (1-handles.saturation(j))*5;
    dfr   = squeeze(sum(fr>=sats,1));
end
motSVD = [];
if handles.svdmat(j-2,2)
    motMask = handles.motionMask{j-2};
    motSVD=fr'*motMask;
    motSVD = [motSVD(1,:); motSVD];
end
movSVD = [];
if handles.svdmat(j-2,3)
    fr = reshape(frames,[],size(frames,3));
    movMask = handles.movieMask{j-2};
    movSVD=fr'*movMask;
end
    
movs{1} = [dfr(1);dfr(:)];
movs{2} = motSVD;
movs{3} = movSVD;

if 0
for k = 1:10:1000
    clf
    subplot(2,1,1),
    imagesc(frames(:,:,k))
    subplot(2,1,2),
    mt=zscore(motSVD(:,1:3));
    plot(mt);
    hold all;
    plot(k,mt(k,:),'k*');
drawnow;
pause;
end
end
function drawIM(IntersectionBounds,TransmitLine,laneWidth)
xb1 = IntersectionBounds.xb1;
xb2 = IntersectionBounds.xb2;
xb3 = IntersectionBounds.xb3;
xb4 = IntersectionBounds.xb4;
yb1 = IntersectionBounds.yb1;
yb2 = IntersectionBounds.yb2;
yb3 = IntersectionBounds.yb3;
yb4 = IntersectionBounds.yb4;
rectangle('Position',[xb1 yb2 xb2-xb1 (yb3-yb2)/2])
rectangle('Position',[xb1 (yb3+yb2)/2 xb2-xb1 (yb3-yb2)/2])
rectangle('Position',[xb3 yb2 xb4-xb3 (yb3-yb2)/2])
rectangle('Position',[xb3 (yb3+yb2)/2 xb4-xb3 (yb3-yb2)/2])
rectangle('Position',[xb2 yb1 (xb3-xb2)/2 yb2-yb1])
rectangle('Position',[(xb3+xb2)/2 yb1 (xb3-xb2)/2 yb2-yb1])
rectangle('Position',[xb2 yb3 (xb3-xb2)/2 yb4-yb3])
rectangle('Position',[(xb3+xb2)/2 yb3 (xb3-xb2)/2 yb4-yb3])
rectangle('Position',[xb1 yb2+(yb3-yb2)/6 xb2-xb1 (yb3-yb2)/6])
rectangle('Position',[xb1 yb2+4*(yb3-yb2)/6 xb2-xb1 (yb3-yb2)/6])
rectangle('Position',[xb3 yb2+(yb3-yb2)/6 xb2-xb1 (yb3-yb2)/6])
rectangle('Position',[xb3 yb2+4*(yb3-yb2)/6 xb2-xb1 (yb3-yb2)/6])
rectangle('Position',[xb2+(xb3-xb2)/6 yb1 (xb3-xb2)/6 yb2-yb1 ])
rectangle('Position',[xb2+(xb3-xb2)/6 yb3 (xb3-xb2)/6 yb2-yb1 ])
rectangle('Position',[xb2+4*(xb3-xb2)/6 yb1 (xb3-xb2)/6 yb2-yb1 ])
rectangle('Position',[xb2+4*(xb3-xb2)/6 yb3 (xb3-xb2)/6 yb2-yb1 ])
line([xb2-TransmitLine xb2-TransmitLine],[yb2 yb3],'Color',[0.1 0.2 0.9])
line([xb3+TransmitLine xb3+TransmitLine],[yb2 yb3],'Color',[0.1 0.2 0.9])
line([xb2 xb3],[yb2-TransmitLine yb2- TransmitLine],'Color',[0.1 0.2 0.9])
line([xb2 xb3],[yb3+TransmitLine yb3+TransmitLine],'Color',[0.1 0.2 0.9])
% line([xb1  xb2],[yb2+3*laneWidth yb2+3*laneWidth], 'Color', lines(1))

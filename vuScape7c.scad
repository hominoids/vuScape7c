/*
    vuScape7c Case Copyright 2022 Edward A. Kisiel
    hominoid @ www.forum.odroid.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Code released under GPLv3: http://www.gnu.org/licenses/gpl.html

    20220407 Version 1.0.0    vuScape7c Vu7c SBC Case initial release
    20220423 Version 1.0.1    update sbc_case_builder_library and adjust top standoff size
    
*/

use <./lib/fillets.scad>;
use <./lib/sbc_models.scad>;
use <./lib/sbc_case_builder_library.scad>;

view = "model";                     // viewing mode "platter", "model", "debug"
sbc_model = "c4";                   // sbc "c4"
boom_orientation = "horizontal";    // boom bonnet orientation "none", "horizontal" or "vertical"
boom_speaker = "side";              // speaker location "none", "side", "front"
fan = true;                         // fan (true or false)
vent = true;                        // vent (true or false)
bracket = "speaker";                // bracket style "none","arch","speaker"

sbc_off = false;                    // sbc off in model view (true or false)
vu7c_off = false;                   // vu7c off in model view (true or false)
move_bottom = 0;                    // moves top mm in model view or < 0 = off
move_top = 0;                       // moves bottom mm in model view or < 0 = off
move_cover = 0;                     // moves sbc cover mm in model view or < 0 = off    

case_offset_x =3.5;                 // additional case x axis size 3.5
case_offset_y = 20;                 // additional case y axis size 9mm for no boom_bonnet or 20 side,44 front speakers
case_offset_tz = 4.5;               // additional case top z axis size 4.5 min.
case_offset_bz = 0;                 // additional case bottom z axis size

wallthick = 2.5;                    // case wall thickness
floorthick = 2;                     // case floor thickness
topthick = 2;                       // case top thickness
sidethick = 2;                      // case side thickness
gap = 2;                            // distance between pcb and case

c_width = 112;
c_depth = 68;
c_height = 28;                      // cover height 28 with access panel

c_fillet = 6;                       // corner fillets
fillet = 0;                         // edge fillets
tab_clearance = 8;
view_angle = 15;
lcd_size = [164.85,100,5.48];
pcb_size = [184.5,75,1.6];
view_size = [155,88.5,.125];        // 154.21 x 85.92
pcb_tmaxz = 7.5;
pcb_bmaxz = 5;

width = pcb_size[0]+(2*(wallthick+gap))+case_offset_x;
depth = lcd_size[1]+(2*(wallthick+gap))+case_offset_y;
top_height = pcb_tmaxz+topthick+case_offset_tz;
bottom_height = pcb_bmaxz+floorthick+case_offset_bz;
case_z = bottom_height+top_height;

bottom_standoff=[   8,     // diameter
                   18,     // height (top_height)
                  2.5,     // holesize
                   10,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    0,     // standoff style 0=hex, 1=cylinder
                    1,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
top_standoff=[      6.5,   // radius
                  top_height-topthick,     // height
                  2.7,     // holesize
                   10,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    0,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
mount_standoff=[    7,     // radius
                 10.2,     // height (bottom_height-pcb_z)
                  2.7,     // holesize
                    7,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    1,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
boom_standoff=[     7,     // radius
                    5,     // height (bottom_height-pcb_z)
                  2.7,     // holesize
                    7,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    1,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
                  
adjust = .1;
$fn = 90;

echo(width=width, depth=depth, height=top_height);

/*
$vpt = [8, -6.5, 67];
$vpr = [83.3, 0, $t*360];
$vpd = 590;
*/

// platter view
if (view == "platter") {
    translate([0,0,-11]) case_bottom();
    translate([400,0,42]) rotate([0,180,0]) case_cover();
    translate([0,depth+10,0]) case_top();
    if(boom_speaker == "side") translate([-125,110,13.75]) rotate([0,90,0]) boom_speaker_strap("left");
    if(boom_speaker == "side") translate([-100,110,13.75]) rotate([0,90,0]) boom_speaker_strap("right");
    translate([-170,depth-60,-2.5]) rotate([0,90,0]) bracket(bracket,"left");
    translate([-30,30,-170.5]) rotate([0,-90,0]) bracket(bracket,"right");
    translate([225,150,0]) access_cover([37,53,2],"landscape");
    if(boom_speaker != "none") translate([275,175,0]) rotate([0,0,0]) boom_vring(0);
    }
// model view
if (view == "model") {
    translate([(-width/2)+10,0,27]) rotate([90+view_angle,0,0]){         // 8.5, 27 or 
        if(move_top >= 0) {
            color("grey",1) translate([-10,0,move_top]) case_top();
        }
        if(move_bottom >= 0) {
            color("dimgrey",1) translate([-10,0,1+move_bottom+adjust]) case_bottom();
        }
        if(move_cover >= 0) {
            if(boom_speaker == "none" && boom_orientation == "none") {
                color("grey",1) translate([-10,0,move_cover]) case_cover();
            color("grey",1) translate([(width/2)-wallthick-gap-4.5+16,(depth/2)-wallthick-gap-19,
                bottom_height+top_height+21]) rotate([0,180,0]) access_cover([37,58,2.5],"landscape");
            }
            if(boom_speaker == "front" && boom_orientation == "vertical") {
                color("grey",1) translate([-10,18,move_cover]) case_cover();
                color("grey",1) translate([(width/2)-wallthick-gap-4.5+16,(depth/2)-wallthick-gap-1.25,
                    bottom_height+top_height+21]) rotate([0,180,0]) access_cover([37,58,2.5],"landscape");
            }
            if(boom_speaker == "front" && boom_orientation == "horizontal") {
                color("grey",1) translate([-10,18,move_cover]) case_cover();
                color("grey",1) translate([(width/2)-wallthick-gap-4.5+16,(depth/2)-wallthick-gap-1.25,
                    bottom_height+top_height+21]) rotate([0,180,0]) access_cover([37,58,2.5],"landscape");
            }
            if(boom_speaker == "front" && boom_orientation == "horizontal") {
                color("grey",1) translate([-10,18,move_cover]) case_cover();
            }
            if(boom_speaker == "side" && boom_orientation == "horizontal") {
                color("grey",1) translate([-10,6,move_cover]) case_cover();
                color("grey",1) translate([(width/2)-wallthick-gap-4.5+16,(depth/2)-wallthick-gap-13,
                    bottom_height+top_height+21]) rotate([0,180,0]) access_cover([37,58,2.5],"landscape");
            }
        }
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)-2.5,depth-tab_clearance-gap-105,4+topthick]) 
            vu7_model("down");
        if(boom_speaker == "none") {
            if(bracket == "arch") color("grey") translate([-adjust,0,0]) bracket("arch","left");
            if(bracket == "arch") color("grey") translate([-adjust,0,0]) bracket("arch","right");      
        }
        if(boom_speaker == "side") {
            translate([-9,21.5,15]) rotate([0,-90,0]) boom_speaker();
            translate([width-18.5,21.5,15]) rotate([0,90,0]) boom_speaker();
            translate([(width/2)-gap-wallthick-10-30,11,37.5]) rotate([-105,0,0]) hk_boom(false,"front");
            translate([(width/2)-gap-wallthick-10+14.5,7.5,9.75]) rotate([-105,0,0]) boom_vring(0);
            if(bracket == "none") color("grey",1) translate([-11.5,7,1]) rotate([0,0,0]) boom_speaker_strap("left");
            if(bracket == "none") color("grey",1) translate([width-17.5,36,1]) rotate([0,0,180]) boom_speaker_strap("right");
            if(bracket == "speaker") color("grey") translate([-adjust,0,0]) bracket("speaker","left");
            if(bracket == "speaker") color("grey") translate([2.5,0,0]) bracket("speaker","right");
            if(bracket == "kickstand") color("grey") translate([-adjust,0,0]) bracket("kickstand","left");
            if(bracket == "kickstand") color("grey") translate([2.5,0,0]) bracket("kickstand","right");
        }
        if(boom_speaker == "front") {
            translate([7,18,topthick+4]) rotate([0,180,0]) boom_speaker();
            translate([161,18,topthick+4]) rotate([0,180,0]) boom_speaker();
            if(boom_orientation == "vertical") {
                translate([(width/2)-gap-wallthick-10+30,33.5,5]) rotate([0,0,180]) hk_boom(false,"front");
                translate([(width/2)-gap-wallthick-10-14.5,6.5,8.5]) rotate([0,0,0]) boom_vring(0);
                if(bracket == "arch") color("grey") translate([-adjust,0,0]) bracket("arch","left");
                if(bracket == "arch") color("grey") translate([-adjust,0,0]) bracket("arch","right");
            }
            if(boom_orientation == "horizontal") {
            translate([(width/2)-gap-wallthick-10-30,11,37.5]) rotate([-105,0,0]) hk_boom(false,"front");
            translate([(width/2)-gap-wallthick-10+14.5,7.75,10.5]) rotate([-105,0,0]) boom_vring(0);
                if(bracket == "arch") color("grey") translate([-adjust,0,0]) bracket("arch","left");
                if(bracket == "arch") color("grey") translate([-adjust,0,0]) bracket("arch","right");
            }
        }
    }
}
// debug
if (view == "debug") {
case_top();
//translate([0,0,-11]) case_bottom();
//translate([164.85,0,38]) rotate([0,180,0]) case_cover();
//translate([-150,depth-60,-2.5]) rotate([0,90,0]) bracket("speaker","left");
//translate([-10,30,-170.5]) rotate([0,-90,0]) bracket("speaker","right");
//access_cover([37,58,2],"landscape");
//translate([0,0,14]) rotate([0,90,0]) boom_speaker_strap("left");
//translate([50,0,14]) rotate([0,90,0]) boom_speaker_strap("right");
}


module case_bottom() {
    difference() {
        translate([(width/2)-wallthick-gap+.3,(depth/2)-wallthick-gap+.3,top_height-floorthick]) 
            cube_fillet_inside([width-(wallthick*2)-.6,depth-(wallthick*2)-.6,floorthick], 
                vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1], 
                    top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);        
        translate([20+case_offset_x,30,-1]) cube([120,58,4]);
        translate([76.5+case_offset_x,18.1,-1]) cube([18,12,4]);
        // case bottom standoffs openings
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,3.5,bottom_height+floorthick+adjust]) 
            cylinder(d=3, h=4);
        translate([width-12,3.5,bottom_height+floorthick+adjust]) cylinder(d=3, h=4);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,depth-12,bottom_height+floorthick+adjust]) 
            cylinder(d=3, h=4);
        translate([width-12,depth-12,bottom_height+floorthick+adjust]) cylinder(d=3, h=4);
        // mount standoffs openings
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+2.5,depth-tab_clearance-gap-72,
            bottom_height+floorthick+adjust]) cylinder(d=6.70, h=4);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+2.5,depth-tab_clearance-gap-13.5,
            bottom_height+floorthick+adjust]) cylinder(d=6.70, h=4);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+177.25,depth-tab_clearance-gap-13.5,
            bottom_height+floorthick+adjust]) cylinder(d=6.70, h=4);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+177.25,depth-tab_clearance-gap-72,
            bottom_height+floorthick+adjust]) cylinder(d=6.70, h=4);
        // tab standoffs openings
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+63.5,depth-tab_clearance-gap-1.5,
            bottom_height+floorthick+adjust]) cylinder(d=3, h=4);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+116.5,depth-tab_clearance-gap-1.5,
            bottom_height+floorthick+adjust]) cylinder(d=3, h=4);
        // sbc openings
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+81.5,depth-tab_clearance-gap-26.75,
            top_height-floorthick-2]) cube([53,7,4]);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+107,depth-tab_clearance-gap-65,
            top_height-floorthick-2]) cube([20,5,4]);
        // hdmi opening
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+86,depth-tab_clearance-gap-93,
            top_height-floorthick-2]) cube([18,29,4]);
        // header openings
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+155.5,depth-tab_clearance-gap-71.5,
            top_height-floorthick-2]) cube([5,22,4]);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+145,depth-tab_clearance-gap-33.75,
            top_height-floorthick-2]) cube([5,17,4]);
        // component clearance
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+84.5,depth-tab_clearance-gap-54,
            top_height-floorthick-2]) cube([10,7,4]);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+127.5,depth-tab_clearance-gap-48,
            top_height-floorthick-2]) cube([27.5,7.5,4]);
        translate([((width/2)-gap-wallthick-pcb_size[0]/2)+151.125,depth-tab_clearance-gap-36.5,
            top_height-floorthick-2]) cube([5.75,6,4]);
        // mid bottom standoff holes
        if(boom_speaker == "none" && boom_orientation == "none") {
            translate([(width/2)-wallthick-gap-30.75+4,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                cylinder(d=3.2, h=60);
            translate([(width/2)-wallthick-gap+39.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                cylinder(d=3.2, h=60);
        }
        if(boom_speaker == "front" && boom_orientation == "vertical") {
            color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-46.75-adjust,
                bottom_height-floorthick+5]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-46.75-adjust,
                bottom_height-floorthick+5]) cylinder(d=3.6, h=6);        
        }
        if(boom_speaker == "side") {
            translate([-gap,6.25,top_height-4]) cube([12,30.25,5]);
            translate([width-17-2*(wallthick-gap),6.25,top_height-4]) cube([12,30.25,5]);
         }
        if(boom_speaker == "side" && boom_orientation == "horizontal") {
            translate([(width/2)-gap-wallthick-31,4-gap-adjust,top_height-4]) cube([62,12,5]);
            color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-53.75-adjust,
                bottom_height-floorthick+5]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,
                bottom_height-floorthick+5]) cylinder(d=3.6, h=6);        
        }
        if(boom_speaker == "front" && boom_orientation == "horizontal") {
            translate([(width/2)-gap-wallthick-31,4-gap-adjust,top_height-4]) cube([62,12,5]);
            color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-68.75-adjust,
                bottom_height-floorthick+4]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-68.75-adjust,
                bottom_height-floorthick+4]) cylinder(d=3.6, h=6);
        }
        if(boom_speaker == "front") {
            translate([17,18,top_height-4]) cylinder(d=22, h=4);
            translate([171,18,top_height-4]) cylinder(d=22, h=4);
            translate([17-3.5,18-15,top_height-4]) cube([7,30,6]);
            translate([171-3.5,18-15,top_height-4]) cube([7,30,6]);
        }
        if(boom_orientation == "vertical") {
            translate([(width/2)-gap-wallthick-19.75,depth-tab_clearance-gap-121.65,top_height-6]) 
                slot(5,9,6);
            translate([(width/2)-gap-wallthick-2.5,depth-tab_clearance-gap-111.65,top_height-4]) 
                slot(5,24,6);
            translate([(width/2)-gap-wallthick,depth-tab_clearance-gap-139.5,top_height-6]) 
                cylinder(d=8,h=6);
            translate([(width/2)-gap-wallthick+10,depth-tab_clearance-gap-139.5,top_height-6]) 
                cylinder(d=8,h=6);
            translate([(width/2)-gap-wallthick-28.5,depth-tab_clearance-gap-129.25,top_height-6]) 
                rotate([0,0,90]) slot(5,6,6);
            translate([(width/2)-gap-wallthick+28.25,depth-tab_clearance-gap-129.25,top_height-6]) 
                rotate([0,0,90]) slot(5,6,6);
        }
    }
}

module case_top() {
    difference() {
        union() {
            difference() {
                translate([(width/2)-wallthick-gap,
                    (depth/2)-wallthick-gap,top_height/2]) 
                        cube_fillet_inside([width,depth,top_height], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                                bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                translate([(width/2)-wallthick-gap,(depth/2)-wallthick-gap,(top_height/2)+topthick]) 
                        cube_fillet_inside([width-(wallthick*2),depth-(wallthick*2),top_height], 
                            vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],top=[0,0,0,0],
                                bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                // lcd opening
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+14.5,depth-tab_clearance-gap-97.5,-1]) 
                    slab([view_size[0],view_size[1],4],1);
                // case top standoffs openings
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,3.5,-adjust]) cylinder(d=6.70, h=4);
                translate([width-12,3.5,-adjust]) cylinder(d=6.70, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,depth-12,-adjust]) cylinder(d=6.70, h=4);
                translate([width-12,depth-12,-adjust]) cylinder(d=6.70, h=4);
                // mount standoffs openings
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+2.5,depth-tab_clearance-gap-72,-adjust]) 
                    cylinder(d=6.70, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+2.5,depth-tab_clearance-gap-13.5,-adjust]) 
                    cylinder(d=6.70, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+177.25,depth-tab_clearance-gap-13.5,-adjust]) 
                    cylinder(d=6.70, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+177.25,depth-tab_clearance-gap-72,-adjust])
                    cylinder(d=6.70, h=4);
                // top tab standoff openings
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+63.5,depth-tab_clearance-gap-1.5,-adjust]) 
                    cylinder(d=6.70, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+116.5,depth-tab_clearance-gap-1.5,-adjust]) 
                    cylinder(d=6.70, h=4);
                // mid bottom standoff holes
                if(boom_speaker == "front" && boom_orientation == "vertical") {
                    translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-46.75-adjust,-adjust]) 
                        cylinder(d=6.70, h=4);
                    translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-46.75-adjust,-adjust]) 
                        cylinder(d=6.70, h=4);
                }
                if(boom_speaker == "front" && boom_orientation == "horizontal") {
                    color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,
                        (depth/2)-wallthick-gap-68.75-adjust,-adjust]) cylinder(d=6.70, h=4);
                    color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,
                        (depth/2)-wallthick-gap-68.75-adjust,-adjust]) cylinder(d=6.70, h=4);
                }
                if(boom_speaker == "side" && boom_orientation == "horizontal") {
                    translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                        cylinder(d=6.70, h=4);
                    translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                        cylinder(d=6.70, h=4);
                }
                if(boom_speaker == "none" && boom_orientation == "none") {
                    translate([(width/2)-wallthick-gap-30.75+4,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                        cylinder(d=6.70, h=4);
                    translate([(width/2)-wallthick-gap+39.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                        cylinder(d=6.70, h=4);
                }
                // boom standoffs openings
                if(boom_speaker == "front" && boom_orientation == "vertical") {
                    translate([(width/2)-gap-wallthick-26.5,30,-adjust]) cylinder(d=6.70, h=4);
                    translate([(width/2)-gap-wallthick+26.5,30,-adjust]) cylinder(d=6.70, h=4);
                    translate([(width/2)-gap-wallthick-26.5,2,-adjust]) cylinder(d=6.70, h=4);
                    translate([(width/2)-gap-wallthick+26.5,2,-adjust]) cylinder(d=6.70, h=4);
                }
                // boom bonnet openings
                if(boom_speaker == "side") {
                    translate([(width/2)-gap-wallthick+7,6,-2-adjust]) rotate([-15,0,0]) 
                        slot(5,14,6);
                    translate([(width/2)-gap-wallthick-19,4.5,-2-adjust]) rotate([-15,0,0]) 
                        cylinder(d=5, h=7);
                    translate([(width/2)-gap-wallthick-93,21.5,15]) rotate([-90,0,90]) 
                        cylinder(d=28, h=4.5);
                    translate([(width/2)-gap-wallthick+97.1+adjust,21.5,15]) rotate([-90,0,90]) 
                        cylinder(d=28, h=4.5);
                    translate([(width/2)-gap-wallthick-95,21.5,15]) rotate([-90,0,90]) 
                        cylinder(d=24.5, h=4.5);
                    translate([(width/2)-gap-wallthick+99.1+adjust,21.5,15]) rotate([-90,0,90]) 
                        cylinder(d=24.5, h=4.5);
                }
                if(boom_speaker == "front") {
                    translate([17,18,-adjust]) cylinder(d=24.25, h=4);
                    translate([171,18,-adjust]) cylinder(d=24.25, h=4);
                    if(boom_orientation == "vertical") {
                        translate([(width/2)-gap-wallthick-21.5,-gap-wallthick-adjust,10.5]) 
                            rotate([-90,0,0]) slot(5,14,6);
                        translate([(width/2)-gap-wallthick+19,-gap-wallthick-adjust,8.75]) 
                            rotate([-90,0,0]) cylinder(d=5, h=7);
                    }   
                    if(boom_orientation == "horizontal") {
                    translate([(width/2)-gap-wallthick+7,6,-2-adjust]) rotate([-15,0,0]) slot(5,14,6);
                    translate([(width/2)-gap-wallthick-19,4.5,-2-adjust]) rotate([-15,0,0]) cylinder(d=5, h=7);
                    }   
                }
            }
            // case top standoffs
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,3.5,0]) standoff(top_standoff);
            translate([width-12,3.5,0]) standoff(top_standoff);
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,depth-12,0]) rotate([0,0,30]) 
                standoff(top_standoff);
            translate([width-12,depth-12,0]) rotate([0,0,30]) standoff(top_standoff);        
            // case top standoff supports
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,-.5,0]) cylinder(d=4, h=top_standoff[1]);
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+1,depth-12+4,0]) rotate([0,0,30]) 
                 cylinder(d=4, h=top_standoff[1]);
            translate([width-12,-.5,0])  cylinder(d=4, h=top_standoff[1]);
            translate([width-12,depth-12+4,0]) rotate([0,0,30])  cylinder(d=4, h=top_standoff[1]);           
            // mount standoffs
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+2.5,depth-tab_clearance-gap-72,0]) 
                standoff(mount_standoff);
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+2.5,depth-tab_clearance-gap-13.5,0]) 
                standoff(mount_standoff);
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+177.25,depth-tab_clearance-gap-13.5,0]) 
                standoff(mount_standoff);
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+177.25,depth-tab_clearance-gap-72,0]) 
                standoff(mount_standoff);
            // top tab standoffs
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+63.5,depth-tab_clearance-gap-1.5,0]) 
                standoff(mount_standoff);
            translate([(width/2)-gap-wallthick-pcb_size[0]/2+116.5,depth-tab_clearance-gap-1.5,0]) 
                standoff(mount_standoff);
            // top tab standoff supports
            translate([((width/2)-gap-wallthick-pcb_size[0]/2)+63.5,depth-tab_clearance-gap+2,0]) 
                cylinder(d=4, h=mount_standoff[1]);
            translate([(width/2)-gap-wallthick-pcb_size[0]/2+116.5,depth-tab_clearance-gap+2,0]) 
                cylinder(d=4, h=mount_standoff[1]);
            // mid bottom cover standoffs
            if(boom_speaker == "front" && boom_orientation == "horizontal") {
                color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,
                    (depth/2)-wallthick-gap-68.75-adjust,0]) standoff(top_standoff);
                color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,
                    (depth/2)-wallthick-gap-68.75-adjust,0]) standoff(top_standoff);
            }
            if(boom_speaker == "front" && boom_orientation == "vertical") {
                translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-46.75-adjust,0]) 
                    standoff(top_standoff);
                translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-46.75-adjust,0]) 
                    standoff(top_standoff);
            }
            if(boom_speaker == "side" && boom_orientation == "horizontal") {
                translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-53.75-adjust,0]) 
                    standoff(top_standoff);
                translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,0]) 
                    standoff(top_standoff);
            }
            if(boom_speaker == "none" && boom_orientation == "none") {
                translate([(width/2)-wallthick-gap-30.75+4,(depth/2)-wallthick-gap-53.75-adjust,0]) 
                    standoff(top_standoff);
                translate([(width/2)-wallthick-gap+39.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,0]) 
                    standoff(top_standoff);
            }
            // boom standoffs
            if(boom_speaker == "front" && boom_orientation == "vertical") {
                translate([(width/2)-gap-wallthick-26.5,30,0]) standoff(boom_standoff);
                translate([(width/2)-gap-wallthick+26.5,30,0]) standoff(boom_standoff);
                translate([(width/2)-gap-wallthick-26.5,2,0]) standoff(boom_standoff);
                translate([(width/2)-gap-wallthick+26.5,2,0]) standoff(boom_standoff);
            }
            // boom bonnet support
            if(boom_speaker =="side" || boom_orientation == "horizontal")
                difference() {
                    union() {
                        translate([(width/2)-gap-wallthick-10-20,-gap-adjust,0]) 
                            cube([7,6,top_height-topthick]);
                        translate([(width/2)-gap-wallthick-10+33,-gap-adjust,0]) 
                            cube([7,6,top_height-topthick]);
                    }
                    translate([(width/2)-gap-wallthick-10-20-adjust,1.75,3]) rotate([-15,0,0]) 
                        cube([61,4,top_height]);
                }
            
            if(boom_speaker == "side") {
                // speaker holders
                translate([-gap,7,1]) boom_speaker_holder("clamp",0);
                translate([width-13.75-2*(wallthick-gap)+7.75+adjust,36,2]) rotate([0,0,180]) 
                    boom_speaker_holder("clamp",0);
            }
            if(boom_speaker == "front") {
                translate([17,18,topthick-adjust]) boom_speaker_holder("friction",0);
                translate([171,18,topthick-adjust]) boom_speaker_holder("friction",0);
            }
            // speaker grills
            if(boom_speaker == "side") {
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-6,21.5,15]) rotate([0,-90,0]) 
                    hk_boom_grill("frame",1.5);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+190.5,21.5,15]) rotate([0,90,0]) 
                    hk_boom_grill("frame",1.5);
            }
            if(boom_speaker == "front") {
                translate([17,18,0]) rotate([0,0,0]) hk_boom_grill("flat",2);
                translate([171,18,0]) rotate([0,0,0]) hk_boom_grill("flat",2);
            }
        }
        // boom bonnet support holes
        if(boom_speaker =="side" || boom_orientation == "horizontal") {
            translate([(width/2)-gap-wallthick-10-16.5,5-gap-adjust,6]) 
                rotate([75,0,0]) cylinder(d=3.2, h=8);
            translate([(width/2)-gap-wallthick-10-16.5,1-gap-adjust,7]) 
                rotate([75,0,0]) cylinder(d2=6.75, d1=3.2, h=5);
            translate([(width/2)-gap-wallthick-10+36.5,5-gap-adjust,6]) 
                rotate([75,0,0]) cylinder(d=3.2, h=8);
            translate([(width/2)-gap-wallthick-10+36.5,1-gap-adjust,7]) 
                rotate([75,0,0]) cylinder(d2=6.75, d1=3.2, h=5);
        }
        // clean outsides
        translate([-250,-250,-1+adjust]) cube([500,500,1]);
        translate([(width/2)-wallthick-gap,(depth/2)-wallthick-gap,top_height/2]) 
            cube_negative_fillet([width,depth,top_height], radius=-1,
                vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                        bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
    }
}


module case_cover() {

    difference() {
        union() {
            difference() {
                translate([(width/2)-wallthick-gap+14,
                    (depth/2)-wallthick-gap+8,bottom_height+(c_height/2)+7]) 
                        cube_fillet_inside([c_width,c_depth,c_height], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                                top=[fillet,fillet,fillet,fillet,fillet], 
                                    bottom=[0,0,0,0], $fn=90);
                translate([(width/2)-wallthick-gap+14,(depth/2)-wallthick-gap+8,
                    bottom_height+(top_height/2)-floorthick]) 
                        cube_fillet_inside([c_width-(wallthick*2),c_depth-(wallthick*2),2*c_height+adjust], 
                            vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],
                                top=[fillet,fillet,fillet,fillet,fillet],
                                    bottom=[0,0,0,0], $fn=90);
                // cooling vents-fan
                if(vent == true) {
                    translate([(width/2)-wallthick-gap-34,
                        (depth/2)-wallthick-gap+2,bottom_height+top_height+16]) 
                            vent(12,2,8,1,4,1,"horizontal");
                    translate([(width/2)-wallthick-gap-34,
                        (depth/2)-wallthick-gap+22,bottom_height+top_height+16]) 
                            vent(18,2,8,1,5,1,"horizontal");
                    translate([(width/2)-wallthick-gap-34,
                        (depth/2)-wallthick-gap-19,bottom_height+top_height+16]) 
                            vent(18,2,8,1,5,1,"horizontal");
                }
                if(fan == true) {
                    translate([(width/2)-wallthick-gap+26,
                        (depth/2)-wallthick-gap-11.5,bottom_height+top_height+16]) 
                            fan_mask(40,8,2);
                }
                // access cover opening
                translate([(width/2)-wallthick-gap-4.5,
                    (depth/2)-wallthick-gap-19.75,bottom_height+top_height+16]) 
                        cube([20,56.75,8]);
                translate([(width/2)-wallthick-gap-8.5,
                    (depth/2)-wallthick-gap+3.75,bottom_height+top_height+16]) 
                        slab([5.5,10.5,floorthick+4],5.5);
                translate([(width/2)-wallthick-gap-9.125,
                    (depth/2)-wallthick-gap+9,bottom_height+top_height+13.5]) 
                        cylinder(d=3,h=8);
                // hdmi opening
                translate([(width/2)-wallthick-gap-7,
                    (depth/2)-wallthick-gap-35.5,bottom_height+(top_height/2)]) cube([20,4+adjust,24]);              
                // hdmi opening
                translate([(width/2)-wallthick-gap-7,
                    (depth/2)-wallthick-gap-27.5,bottom_height+(top_height/2)-adjust]) cube([20,6+adjust,26+2*adjust]);
                // lan openings
                translate([(width/2)-wallthick-gap-36,
                    (depth/2)-wallthick-gap-20.5,bottom_height+(top_height/2)+16.25]) 
                        rotate([0,180,0]) cube([6.56,16.5,14]);
                // usb openings
                translate([(width/2)-wallthick-gap-36,
                    (depth/2)-wallthick-gap-1,bottom_height+(top_height/2)+16.5-adjust]) 
                        rotate([0,180,0]) cube([12,15.25,16.5]);
                translate([(width/2)-wallthick-gap-36,
                    (depth/2)-wallthick-gap+17,bottom_height+(top_height/2)+16.5-adjust]) 
                        rotate([0,180,0]) cube([12,15.25,16.5]);
                // power opening
                translate([(width/2)-wallthick-gap+34.75,
                    (depth/2)-wallthick-gap-20,bottom_height+(top_height/2)+6.25]) 
                        rotate([90,0,0]) slab([7,7,6],2);
                translate([(width/2)-wallthick-gap+33.25,
                    (depth/2)-wallthick-gap-24.5-adjust,bottom_height+(top_height/2)+4.75]) 
                        rotate([90,0,0]) slab([10,10,1.5],2);
                // usb-otg opening
                translate([(width/2)-wallthick-gap+22,
                    (depth/2)-wallthick-gap-23.5,bottom_height+(top_height/2)+12.25]) 
                        rotate([0,0,0]) microusb_open();
                translate([(width/2)-wallthick-gap+22.5,
                    (depth/2)-wallthick-gap-24.75,bottom_height+(top_height/2)+14.25]) 
                        rotate([90,0,0]) slot(7,6,1.5);
            }
            // access port
            translate([(width/2)-wallthick-gap-4.5+26.1-adjust,
                (depth/2)-wallthick-gap-19.25,bottom_height+top_height+21]) rotate([0,180,0])
                    access_port([37,58,2],"landscape");
            // hdmi bump out
            if(boom_speaker == "none" && boom_orientation == "none") {
                difference() {
                    union() {
                        translate([(width/2)-wallthick-gap-9,
                            (depth/2)-wallthick-gap-43.5-adjust,bottom_height+(top_height/2)]) 
                                slab_r([24,18,c_height],[3.5,.1,.1,3.5]);
                        // bottom tabs
                        translate([(width/2)-wallthick-gap-35,(depth/2)-wallthick-gap-59-adjust,
                            bottom_height-floorthick+9]) slab_r([15.5,33.5,3],[3.5,.1,.1,3.5]);
                        translate([(width/2)-wallthick-gap+48,(depth/2)-wallthick-gap-59-adjust,
                            bottom_height-floorthick+9]) slab_r([15.5,33.5,3],[3.5,.1,.1,3.5]);
                    }
                    translate([(width/2)-wallthick-gap-7,
                        (depth/2)-wallthick-gap-41.5-adjust,bottom_height+(top_height/2)+adjust-2]) 
                            slab_r([20,20,c_height],[3.5,.1,.1,3.5]);
                }
            }
            if(boom_speaker == "front" && boom_orientation == "vertical") {
                difference() {
                    union() {
                        translate([(width/2)-wallthick-gap-9,
                            (depth/2)-wallthick-gap-54.5-adjust,bottom_height+(top_height/2)]) 
                                slab_r([24,31,c_height],[.1,.1,.1,.1]);
                        // bottom tabs
                        translate([(width/2)-wallthick-gap-45.75,(depth/2)-wallthick-gap-72.5-adjust,
                            bottom_height-floorthick+9]) slab_r([19.75,15.5,3],[3.5,3.5,.1,.1]);
                        translate([(width/2)-wallthick-gap+27.75,(depth/2)-wallthick-gap-72.5-adjust,
                            bottom_height-floorthick+9]) slab_r([19.75,15.5,3],[.1,.1,3.5,3.5]);
                    }
                    translate([(width/2)-wallthick-gap-7,
                        (depth/2)-wallthick-gap-55.5-adjust,bottom_height+(top_height/2)-adjust]) 
                            slab_r([20,33,c_height-2],[.1,.1,.1,.1]);
                }
                // boom cover
                difference() {
                    translate([(width/2)-wallthick-gap-26,
                        (depth/2)-wallthick-gap-76,bottom_height+(top_height/2)]) 
                            slab_r([54,22,c_height],[3.5,3.5,3.5,3.5]);
                    translate([(width/2)-wallthick-gap-24,
                        (depth/2)-wallthick-gap-74,bottom_height+(top_height/2)-2-adjust]) 
                            slab_r([50,18+adjust,c_height],[3.5,3.5,3.5,3.5]);
                }
            }
            if(boom_speaker == "side" && boom_orientation == "horizontal") {
                difference() {
                    translate([(width/2)-wallthick-gap-26,
                        (depth/2)-wallthick-gap-47-adjust,bottom_height+(top_height/2)]) 
                            slab_r([43,23,c_height],[.1,.1,.1,.1]);
                    translate([(width/2)-wallthick-gap-24,
                        (depth/2)-wallthick-gap-48-adjust,bottom_height+(top_height/2)-adjust]) 
                            slab_r([39,25,c_height-2],[.1,.1,.1,.1]);
                }
                // boom cover
                translate([0,-3,0]) {
                    difference() {
                        union() {
                            difference() {
                                translate([(width/2)-wallthick-gap-36,
                                    (depth/2)-wallthick-gap-67.5,bottom_height+(top_height/2)]) 
                                        slab_r([74,26,c_height],[3.5,3.5,3.5,3.5]);
                                translate([(width/2)-wallthick-gap-37,(depth/2)-wallthick-gap-69,
                                    bottom_height+c_height-25]) rotate([90-view_angle,0,0])
                                        slab_r([76,45.5,12],[3.5,3.5,3.5,3.5]);
                            }
                            // bottom tabs
                            translate([(width/2)-wallthick-gap-45.75,(depth/2)-wallthick-gap-67.375-adjust,
                                bottom_height-floorthick+9]) slab_r([12.75,15.5,3],[3.5,3.5,.1,.1]);
                            translate([(width/2)-wallthick-gap+34.75,(depth/2)-wallthick-gap-67.375-adjust,
                                bottom_height-floorthick+9]) slab_r([12.75,15.5,3],[.1,.1,3.5,3.5]);
                        }
                        difference() {
                            translate([(width/2)-wallthick-gap-34,
                                (depth/2)-wallthick-gap-64.5,bottom_height+(top_height/2)-2-adjust]) 
                                    slab_r([70,20+adjust,c_height],[3.5,3.5,3.5,3.5]);
                                translate([(width/2)-wallthick-gap-37,(depth/2)-wallthick-gap-67,
                                    bottom_height+c_height-27]) rotate([90-view_angle,0,0])
                                        slab_r([76,45.5,12],[3.5,3.5,3.5,3.5]);
                        }
                    }
                }
            }
            if(boom_speaker == "front" && boom_orientation == "horizontal") {
                difference() {
                    translate([(width/2)-wallthick-gap-26,
                        (depth/2)-wallthick-gap-47-adjust-24.5,bottom_height+(top_height/2)]) 
                            slab_r([43,46,c_height],[.1,.1,.1,.1]);
                    translate([(width/2)-wallthick-gap-24,
                        (depth/2)-wallthick-gap-48-adjust-24.5,bottom_height+(top_height/2)-adjust]) 
                            slab_r([39,48,c_height-2],[.1,.1,.1,.1]);
                }
                // boom cover
                translate([0,-27,0]) {
                    difference() {
                        union() {
                            difference() {
                                translate([(width/2)-wallthick-gap-36,
                                    (depth/2)-wallthick-gap-67.5,bottom_height+(top_height/2)]) 
                                        slab_r([74,23.5,c_height],[3.5,3.5,3.5,3.5]);
                                translate([(width/2)-wallthick-gap-37,(depth/2)-wallthick-gap-69,
                                    bottom_height+c_height-25]) rotate([90-view_angle,0,0])
                                        slab_r([76,45.5,12],[3.5,3.5,3.5,3.5]);
                            }
                            // bottom tabs
                            translate([(width/2)-wallthick-gap-45.75,(depth/2)-wallthick-gap-67.5-adjust,
                                bottom_height-floorthick+9]) slab_r([12.75,15.5,3],[3.5,3.5,.1,.1]);
                            translate([(width/2)-wallthick-gap+34.75,(depth/2)-wallthick-gap-67.5-adjust,
                                bottom_height-floorthick+9]) slab_r([12.75,15.5,3],[.1,.1,3.5,3.5]);
                        }
                        difference() {
                            translate([(width/2)-wallthick-gap-34,
                                (depth/2)-wallthick-gap-65.5,bottom_height+(top_height/2)-2-adjust]) 
                                    slab_r([70,19.5+adjust,c_height],[3.5,3.5,3.5,3.5]);
                                translate([(width/2)-wallthick-gap-37,(depth/2)-wallthick-gap-67,
                                    bottom_height+c_height-25]) rotate([90-view_angle,0,0])
                                        slab_r([76,45.5,12],[3.5,3.5,3.5,3.5]);
                        }
                    }
                }
            }
            // top tabs
            translate([(width/2)-wallthick-gap-36.5,(depth/2)-wallthick-gap+40-adjust,
                bottom_height-floorthick+9]) slab_r([15.5,16.25,3],[.1,3.5,3.5,.1]);
            translate([(width/2)-wallthick-gap+16.5,(depth/2)-wallthick-gap+40-adjust,
                bottom_height-floorthick+9]) slab_r([15.5,16.25,3],[.1,3.5,3.5,.1]);       
        }
        // top tab holes
        if(boom_speaker == "none" && boom_orientation == "none") {
            color("dimgray") translate([(width/2)-wallthick-gap-36+7.25,(depth/2)-wallthick-gap+36.5+15.5-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+17+7.25,(depth/2)-wallthick-gap+36.5+15.5-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
        }
        else {
            color("dimgray") translate([(width/2)-wallthick-gap-36+7.25,(depth/2)-wallthick-gap+36.5+15-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+17+7.25,(depth/2)-wallthick-gap+36.5+15-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
        }
        // bottom tab holes and openings
        if(boom_speaker == "none" && boom_orientation == "none") {
            translate([(width/2)-wallthick-gap-30.75+4,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                cylinder(d=3.2, h=60);
            translate([(width/2)-wallthick-gap+39.75+15.75,(depth/2)-wallthick-gap-53.75-adjust,-adjust]) 
                cylinder(d=3.2, h=60);            
        }
        if(boom_speaker == "front" && boom_orientation == "vertical") {
            // hdmi bump opening
            translate([(width/2)-wallthick-gap-7,(depth/2)-wallthick-gap-56.5,bottom_height+(top_height/2)-adjust]) 
                cube([20,23,c_height-2]);
            // bottom tab holes
            color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-64.775-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-64.775-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
        }
        if(boom_speaker == "side" && boom_orientation == "horizontal") {
            // hdmi bump opening
            translate([(width/2)-wallthick-gap-24,(depth/2)-wallthick-gap-56.5,bottom_height+(top_height/2)-adjust]) 
                cube([39,36,c_height-2]);
            // bottom tab holes
            color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-59.775-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-59.775-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
        }
        if(boom_speaker == "front" && boom_orientation == "horizontal") {
            // hdmi bump opening
            translate([(width/2)-wallthick-gap-24,(depth/2)-wallthick-gap-73,bottom_height+(top_height/2)-adjust]) 
                cube([39,50,c_height-2]);
            // bottom tab holes
            color("dimgray") translate([(width/2)-wallthick-gap-45.75+4,(depth/2)-wallthick-gap-86.75-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
            color("dimgray") translate([(width/2)-wallthick-gap+27.75+15.75,(depth/2)-wallthick-gap-86.75-adjust,
                bottom_height-floorthick+8]) cylinder(d=3.6, h=6);
        }
    }
}


module bracket(style,side) {

    if(style == "arch") {    
        // left bracket
        if(side == "left") {
            difference() {
                union() {
                    translate([-2*(wallthick+gap)+.5,(depth/2)-wallthick-gap-10,top_height+3]) 
                        cube_fillet_inside([12,depth+18,6], 
                            vertical=[0,c_fillet,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                
                    translate([-2*(wallthick+gap)+.5,-wallthick-gap-6.25,top_height+42]) rotate([90-view_angle,0,0])
                        cube_fillet_inside([12,100,6], 
                            vertical=[0,0,0,0], top=[0,0,0,0], 
                                bottom=[8,0,8,0], $fn=90);
                    difference() {
                        translate([-14.5,-15,10]) rotate([0,90,0]) cylinder(d=100, h=12, $fn=360);
                        translate([-15.5-1,-15,10]) rotate([0,90,0]) cylinder(d=94, h=12+3, $fn=360);
                    }
                }
                // holes
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)+5.5,18,top_height-adjust]) cylinder(d=22, h=12);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,3.5,bottom_height+floorthick+adjust]) 
                    cylinder(d=3, h=15);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,depth-12,bottom_height+floorthick+adjust]) 
                    cylinder(d=3, h=15);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,3.5,bottom_height+floorthick+adjust+8]) 
                    cylinder(d=6, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,depth-12,bottom_height+floorthick+adjust+8]) 
                    cylinder(d=6, h=4);
                // trim
                if(boom_speaker == "none") {
                    translate([-2*(wallthick+gap)-6.5,(depth/2)-wallthick-gap-50,top_height-46]) cube([14,38,46]);
                    translate([-2*(wallthick+gap)-6.5,(depth/2)-wallthick-gap-140,top_height-56]) cube([14,98,46]);
                    translate([-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-135.4,top_height-15]) rotate([-view_angle,0,0]) 
                        cube([50,50,140]);
                }
                else {
                    translate([-2*(wallthick+gap)-6.5,(depth/2)-wallthick-gap-50,top_height-46]) cube([14,18,46]);
                    translate([-2*(wallthick+gap)-6.5,(depth/2)-wallthick-gap-140,top_height-56]) cube([14,98,46]);
                    translate([-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-152.6,top_height-15]) rotate([-view_angle,0,0]) 
                        cube([50,50,140]);
                }
            }          
        }
        // right bracket
        if(side == "right") {
            difference() {
                union() {
                    translate([width-2*(wallthick+gap)+.5-12,(depth/2)-wallthick-gap-10,top_height+3]) 
                        cube_fillet_inside([12,depth+18,6], 
                            vertical=[c_fillet,0,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    translate([width-2*(wallthick+gap)+.5-12,-wallthick-gap-6.25,top_height+42]) rotate([90-view_angle,0,0])
                        cube_fillet_inside([12,100,6], 
                            vertical=[0,0,0,0], top=[0,0,0,0], 
                                bottom=[8,0,8,0], $fn=90);         
                    difference() {
                        translate([width-2*(wallthick+gap)-17.5,-15,10]) rotate([0,90,0]) cylinder(d=100, h=12, $fn=360);
                        translate([width-2*(wallthick+gap)-17.5-1,-15,10]) rotate([0,90,0]) cylinder(d=94, h=12+3, $fn=360);
                    }
                }
                // holes
                translate([((width/2)-2*(gap+wallthick)+pcb_size[0]/2)-21,18,top_height-adjust]) cylinder(d=22, h=12);
                translate([width-12-10,3.5,bottom_height+floorthick+adjust]) cylinder(d=3, h=15);
                translate([width-12-10,depth-12,bottom_height+floorthick+adjust]) cylinder(d=3, h=15);
                translate([width-12-10,3.5,bottom_height+floorthick+adjust+8]) cylinder(d=6, h=4);
                translate([width-12-10,depth-12,bottom_height+floorthick+adjust+8]) cylinder(d=6, h=4);
                // trim
                if(boom_speaker == "none") {
                    translate([width-2*(wallthick+gap)-18,(depth/2)-wallthick-gap-50,top_height-46]) cube([14,38,46]);
                    translate([width-2*(wallthick+gap)-18,(depth/2)-wallthick-gap-140,top_height-56]) cube([14,98,46]);
                    translate([width-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-135.4,top_height-15]) 
                        rotate([-view_angle,0,0]) cube([50,50,140]);
                }
                else {
                    translate([width-2*(wallthick+gap)-18,(depth/2)-wallthick-gap-50,top_height-46]) cube([14,18,46]);
                    translate([width-2*(wallthick+gap)-18,(depth/2)-wallthick-gap-140,top_height-56]) cube([14,98,46]);
                    translate([width-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-152.6,top_height-15]) 
                        rotate([-view_angle,0,0]) cube([50,50,140]);
                }
            }
        }
    }
    if(style == "speaker") {
        // left bracket
        if(side == "left") {
            difference() {
                union() {
                    translate([-2*(wallthick+gap)+3,(depth/2)-wallthick-gap-9,top_height+3]) 
                        cube_fillet_inside([16.75,depth+18,6], 
                            vertical=[0,c_fillet,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                
                    translate([-2*(wallthick+gap)+3,-wallthick-gap-6.25,top_height+42]) rotate([90-view_angle,0,0])
                        cube_fillet_inside([16.75,100,6], 
                            vertical=[0,0,0,0], top=[0,0,0,0], 
                                bottom=[8,0,8,0], $fn=90);
                    // speaker housing
                    translate([-11.4,6.85,1]) rotate([0,0,0]) {
                        translate([5.4,16.75,top_height+(topthick/2)-1]) cube_fillet_inside([16.75,55,topthick], 
                            vertical=[6,1,6,1], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                        translate([-3,14.5,top_height]) rotate([0,90,0]) cylinder(d=35,h=13.75);
                        translate([10.75-adjust,14.5,top_height]) rotate([0,90,0]) cylinder(d=35,h=3.125);
                    }
                    difference() {
                        translate([-14.375,-15,10]) rotate([0,90,0]) cylinder(d=114, h=16.75, $fn=360);
                        translate([-14.375-1,-15,10]) rotate([0,90,0]) cylinder(d=108, h=16.75+3, $fn=360);
                    }
                }
                // holes
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,3.5,bottom_height+floorthick+adjust]) 
                    cylinder(d=3, h=15);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,depth-12,bottom_height+floorthick+adjust]) 
                    cylinder(d=3, h=15);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,3.5,bottom_height+floorthick+adjust+8]) 
                    cylinder(d=6, h=4);
                translate([((width/2)-gap-wallthick-pcb_size[0]/2)-10+1,depth-12,bottom_height+floorthick+adjust+8]) 
                    cylinder(d=6, h=4);
                // trim
                translate([-2*(wallthick+gap)-8.5,(depth/2)-wallthick-gap-50,top_height-46]) cube([20,58,46]);
                translate([-2*(wallthick+gap)-8.5,(depth/2)-wallthick-gap-140,top_height-62]) cube([20,150,46]);
                translate([-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-139.6,top_height-15]) rotate([-view_angle,0,0]) 
                    cube([50,50,140]);
                // speaker holders openings
                translate([-11.4,6.85,1])  rotate([0,0,0]) {
                    translate([-3-adjust,14.5,14]) rotate([0,90,0]) cylinder(d=30.8, h=4.5);
                    translate([-3-adjust,14.5,14]) rotate([0,90,0]) cylinder(d=32.8, h=2);
                    translate([-2.75,14.5,14]) rotate([0,90,0]) cylinder(d=28, h=14.5);
                    translate([-4.55,-4,-4]) cube([20,37,topthick+15]);
                    translate([4.15,-3.4,-adjust]) cylinder(d=3.2, h=20);
                    translate([4.15,-3.4,15]) cylinder(d=6, h=10);
                    translate([5.75,40,-adjust]) cylinder(d=3.2, h=50);
                    translate([5.75,40,16]) cylinder(d=6, h=10);
                }
            }
        }
        // right bracket
        if(side == "right") {
            difference() {
                union() {
                    translate([width-2*(wallthick+gap)+.5-12-4.75,(depth/2)-wallthick-gap-9,top_height+3]) 
                        cube_fillet_inside([16.75,depth+18,6], 
                            vertical=[c_fillet,0,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                    translate([width-2*(wallthick+gap)+.5-12-4.75,-wallthick-gap-6.25,top_height+42]) rotate([90-view_angle,0,0])
                        cube_fillet_inside([16.75,100,6], 
                            vertical=[0,0,0,0], top=[0,0,0,0], bottom=[8,0,8,0], $fn=90);
                    // speaker housing
                    translate([177.25,35.95,1]) rotate([0,0,180]) {
                        translate([5.4,13,top_height+(topthick/2)-1]) cube_fillet_inside([16.75,55,topthick], 
                            vertical=[1,6,1,1], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                        translate([-3,14.5,top_height]) rotate([0,90,0]) cylinder(d=35,h=13.75);
                        translate([10.75-adjust,14.5,top_height]) rotate([0,90,0]) cylinder(d=35,h=3.225);
                    }         
                    difference() {
                        translate([width-2*(wallthick+gap)-17.625-7,-15,10]) rotate([0,90,0]) cylinder(d=114, h=16.75, $fn=360);
                        translate([width-2*(wallthick+gap)-17.625-1-7,-15,10]) rotate([0,90,0]) cylinder(d=108, h=16.75+3, $fn=360);
                    }
                }
                // holes
                translate([width-12-12.5,depth-12,bottom_height+floorthick+adjust]) cylinder(d=3, h=15);
                translate([width-12-12.5,depth-12,bottom_height+floorthick+adjust+8]) cylinder(d=6, h=4);
                // trim
                translate([width-2*(wallthick+gap)-28,(depth/2)-wallthick-gap-50,top_height-46]) cube([24,38,46]);
                translate([width-2*(wallthick+gap)-28,(depth/2)-wallthick-gap-140,top_height-62]) cube([24,150,46]);
                translate([width-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-139.6,top_height-15]) 
                    rotate([-view_angle,0,0]) cube([50,50,140]);
                // speaker holders openings
                translate([177.25,35.95,1])  rotate([0,0,180]) {
                    translate([-3-adjust,14.5,14]) rotate([0,90,0]) cylinder(d=30.8, h=4.5);
                    translate([-3-adjust,14.5,14]) rotate([0,90,0]) cylinder(d=32.8, h=2);
                    translate([-2.75,14.5,14]) rotate([0,90,0]) cylinder(d=28, h=14.5);
                    translate([-4.55,-4,-4]) cube([20,37,topthick+15]);
                    translate([4.5,32.5,-adjust]) cylinder(d=3.2, h=50);
                    translate([4.5,32.5,15]) cylinder(d=6, h=10);
                    translate([10.75,-11,-adjust]) cylinder(d=3.2, h=50);
                    translate([10.75,-11,16]) cylinder(d=6, h=10);
                }
            }
        }
    }
    if(style == "kickstand") {
        difference() {
            union() {
                translate([10,depth-25,15]) rotate([60,0,0]) cube([10,5,110]);
                translate([width-41,depth-25,15]) rotate([60,0,0]) cube([10,5,110]);
            }
            #translate([0,-10,0]) cube([190,10,10]);
        }

    }
}



module vu7_model(orientation) {
    if(orientation == "up") {
        if(vu7c_off == false) hk_vu7c(false, true);
        if(sbc_off == false && sbc_model == "c4") translate([31.25,30,-18]) sbc(sbc_model);
        if(sbc_off == false && sbc_model == "n2+") translate([141.25,-5,-25.5]) rotate([0,0,90]) 
            sbc(sbc_model);
    }
    if(orientation == "down") { 
        rotate([0,180,0]) {
        if(vu7c_off == false) translate([-164.85,0,-6]) hk_vu7c(false, true);
        if(sbc_off == false && sbc_model == "c4") translate([31.25-164.85,30,-25]) sbc(sbc_model);
        if(sbc_off == false && sbc_model == "n2+") translate([141.25-184.6,-5,-25.5]) rotate([0,0,90]) 
            sbc(sbc_model);
        }
    }
}
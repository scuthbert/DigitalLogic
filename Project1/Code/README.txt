In the MAX10_Eval_Baseline project,the GPIOs are not used a LVDS pins. 
If you want to you use as LVDS pins , use the following procedure :
	(i) For LVDS pins , you should declare only the P pin in the top.v.
	    DON'T Specify the N pin. Fitter assigns the N pin by default.
	(ii) Assign Pin Number for P Pin only.
	(iii) Assign LVDS I/O standard for the P Pin.

Common Errors faced when using LVDS pins
1.Pad <number> of non-differential I/O pin '<name>' in pin location <name> is too close to pad <number> of differential I/O pin '<name>' in pin location <name> -- pads must be separated by a minimum of <number> <name>. Use Pad View of Pin Planner to debug.
CAUSE:	You assigned the specified I/O pin with a non-differential I/O standard assignment to the specified pin location in the device that is too close to the specified differential pin in the specified location. Differential and non-differential I/O pins must be separated by the specified amount of device resources. One HardCopy II pad group corresponds to one Stratix II Logic Array Block (LAB) row and consists of four pads. Depending on the location within the pad group 4 to 7 pad spacing is needed between the differential and non-differential pins to skip a pad group.
ACTION:	Use the Pad View window of the Pin Planner to check the pad placement, and then assign one of the conflicting I/O pins to a different location.

2.Error (169175): Pin <name> with LVDS I/O standard needs a differential output buffer which is not available on location <name>.
CAUSE:	You may get this error message during compilation in the Quartus® II software if you have assigned the IO standard LVDS to an IO pin which does not support true LVDS outputs.
ACION:	To avoid this error use the Emulated LVDS standard assignment LVDS_E_3R or LVDS_E_1R.
NOTE: To use emulated LVDS standards you need additional resistors on your board. Refer to the handbook of the respective target device for more information.

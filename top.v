
module top(CLOCK_50, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B, KEY, SW, HEX0, HEX1);
//VGA Outputs
output	VGA_CLK;   	// VGA Clock
output	VGA_HS;		// VGA H_SYNC
output	VGA_VS;		// VGA V_SYNC
output	VGA_BLANK_N;	// VGA BLANK
output	VGA_SYNC_N;	// VGA SYNC
output	[9:0]	VGA_R; 	// VGA Red[9:0]
output	[9:0]	VGA_G;	// VGA Green[9:0]
output	[9:0]	VGA_B; 	// VGA Blue[9:0]

//Other user inputs + clock 
input CLOCK_50;	//50 MHz
input [5:0] SW;
input [3:0] KEY;
input [6:0] HEX0, HEX1;

//Wires
wire resetn = KEY[0];	 
wire userCont = key[1];
wire plot;

//signal for controller
wire reg dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken;
wire [2:0] player1Choice;
wire [2:0] player2Choice;

assign resetn = KEY[0];
assign clk = CLOCK_50;
assign player1Choice = SW[2:0]
assign player2Choice = SW[2:0]

`define cat 3'b001
`define dog 3'b010
`define chicken 3'b100

// Create an Instance of a VGA controller - there can be only one!
// Define the number of colours as well as the initial background
// image file (.MIF) for the controller.
vga_adapter VGA(.resetn(resetn), .clock(CLOCK_50), .colour(color), .x(x), .y(y), .plot(plot), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK(VGA_BLANK_N),.VGA_SYNC(VGA_SYNC_N), .VGA_CLK(VGA_CLK));
defparam VGA.RESOLUTION = "160x120";
defparam VGA.MONOCHROME = "FALSE";
defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
defparam VGA.BACKGROUND_IMAGE = "black.mif";

//Datapath
datapath datapathInstant(.clk(CLOCK_50), .xInitReset(xInitReset), .xInitLoad(xInitLoad), .yInitReset(yInitReset), .yInitLoad(yInitLoad), .xCountUp(xCountUp), .xReset(xReset), .xLoad(xLoad), .xStart(xStart), .yCountUp(yCountUp), .yReset(yReset), .yLoad(yLoad), .yStart(yStart), .xySel(xySel), .black(black), .playerReset(playerReset), .winner1(winner1), .winner2(winner2), .playerLoad(playerLoad), .addressScreenCounterReset(addressScreenCounterReset), .screenCountLoad(screenCountLoad), .addressSpriteCounterReset(addressSpriteCounterReset), .spriteCountLoad(spriteCountLoad), .yInitSel(yInitSel), .xInitSel(xInitSel), .memorySel(memorySel), .x(x), .y(y), .color(color), .player1(player1), .player2(player2));

//Controller
controller controlInstant(.clk(CLOCK_50), .userCont(userCont), .dogDog(dogDog), .dogCat(dogCat), .dogChicken(dogChicken), .catDog(catDog), .catCat(catCat), .catChicken(catChicken), .chickenDog(chickenDog), .chickenCat(chickenCat), .chickenChicken(chickenChicken), .xInitReset(xInitReset), .xInitLoad(xInitLoad), .yInitReset(yInitReset), .yInitLoad(yInitLoad), .xCountUp(xCountUp), .xReset(xReset), .xLoad(xLoad), .xStart(xStart), .yCountUp(yCountUp), .yReset(yReset), .yLoad(yLoad), .yStart(yStart), .xySel(xySel), .black(black), .playerReset(playerReset), .winner1(winner1), .winner2(winner2), .playerLoad(playerLoad), .delaySignalReset(delaySignalReset), .addressScreenCounterReset(addressScreenCounterReset), .screenCountLoad(screenCountLoad), .addressSpriteCounterReset(addressSpriteCounterReset), .spriteCountLoad(spriteCountLoad), .yInitSel(yInitSel), .xInitSel(xInitSel), .memorySel(memorySel), plot(plot, scenarioLoad(scenarioLoad));

//Display HEX0 for Player 1 points and HEX1 for Player 2 points
displayHEX HEX0Display (.s(player1), .h(HEX0));
displayeHEX HEX1Displayer (.s(player2), .h(HEX1));

//See which of the 9 scenarios is true
always@(posedge clk) begin
	if(scenarioLoad) begin
	case({player1Choice, player2Choice})
		({`cat,`cat}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b100000000;
		({`cat,`dog}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b010000000;
		({`cat,`chicken}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b001000000;
		({`dog,`cat}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b000100000;
		({`dog,`dog}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b000010000;
		({`dog,`chicken}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b000001000;
		({`chicken,`cat}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b000000100;
		({`chicken,`dog}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b000000010;
		({`chicken,`chicken}): ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b000000001;
		//Default is cat vs cat if user does not give proper inputs
		default: ({dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken}) = 9'b100000000;
	endcase
	end
end

endmodule

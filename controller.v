module controller(clk, userCont, userChoose, userResetGame, dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken, xCountUp, xReset, xLoad, yCountUp, yReset, yLoad, xySel, black, playerReset, winner1, winner2, addressScreenCounterReset, screenCountLoad, memorySel, plot, stateReset, player1Wins, player2Wins);

//Signals controled by user inputs
input clk, userCont, userChoose, userResetGame, stateReset; 
//Signals controlled by internal datapath
input player1Wins, player2Wins, dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken;
//Output to datapath
output reg xCountUp, xReset, xLoad, yCountUp, yReset, yLoad, black, playerReset, winner1, winner2, addressScreenCounterReset, screenCountLoad, plot;

output reg [1:0] xySel;
output reg [6:0] memorySel;

//Signal to wait
wire delay;
reg delaySignalReset;

//States
reg [7:0] nextState;
wire [7:0] currentState;

//Reset everything state
`define s0 8'd0
//Title Screen
`define sTitle1Start1 8'd1
`define sTitle1Start2 8'd2
`define sTitle1 8'd3
`define sTitle2Start1 8'd4
`define sTitle2Start2 8'd5
`define sTitle2 8'd6
`define sTitle3Start1 8'd7
`define sTitle3Start2 8'd8
`define sTitle3 8'd9
//Choose Screen
`define sChoose1Start 8'd10
`define sChoose1 8'd12
`define sChoose2Start 8'd13
`define sChoose2 8'd15
`define sChoose3Start 8'd16
`define sChoose3 8'd18
//CatDog Sreens
`define sCatDog5Start1 8'd31  
`define sCatDog5Start2 8'd32  
`define sCatDog5 8'd33
`define sCatDog6Start1 8'd34  
`define sCatDog6Start2 8'd35  
`define sCatDog6 8'd36
`define sCatDog7Start1 8'd37  
`define sCatDog7Start2 8'd38  
`define sCatDog7 8'd39
`define sCatDog8Start1 8'd40  
`define sCatDog8Start2 8'd41  
`define sCatDog8 8'd42
`define sCatDog9Start1 8'd43  
`define sCatDog9Start2 8'd44  
`define sCatDog9 8'd45
//CatChicken Sreens
`define sCatChicken5Start1 8'd58  
`define sCatChicken5Start2 8'd59  
`define sCatChicken5 8'd60
`define sCatChicken6Start1 8'd61  
`define sCatChicken6Start2 8'd62  
`define sCatChicken6 8'd63
`define sCatChicken7Start1 8'd64  
`define sCatChicken7Start2 8'd65  
`define sCatChicken7 8'd66
`define sCatChicken8Start1 8'd67  
`define sCatChicken8Start2 8'd68  
`define sCatChicken8 8'd69
`define sCatChicken9Start1 8'd70  
`define sCatChicken9Start2 8'd71  
`define sCatChicken9 8'd72
//DogCat Sreens
`define sDogCat5Start1 8'd85  
`define sDogCat5Start2 8'd86  
`define sDogCat5 8'd87
`define sDogCat6Start1 8'd88  
`define sDogCat6Start2 8'd89  
`define sDogCat6 8'd90
`define sDogCat7Start1 8'd91  
`define sDogCat7Start2 8'd92  
`define sDogCat7 8'd93
`define sDogCat8Start1 8'd94  
`define sDogCat8Start2 8'd95  
`define sDogCat8 8'd96
`define sDogCat9Start1 8'd97  
`define sDogCat9Start2 8'd98  
`define sDogCat9 8'd99
//DogChicken Sreens
`define sDogChicken5Start1 8'd112 
`define sDogChicken5Start2 8'd113 
`define sDogChicken5 8'd114
`define sDogChicken6Start1 8'd115 
`define sDogChicken6Start2 8'd116 
`define sDogChicken6 8'd117
`define sDogChicken7Start1 8'd118 
`define sDogChicken7Start2 8'd119 
`define sDogChicken7 8'd120
`define sDogChicken8Start1 8'd121 
`define sDogChicken8Start2 8'd122 
`define sDogChicken8 8'd123
`define sDogChicken9Start1 8'd124 
`define sDogChicken9Start2 8'd125 
`define sDogChicken9 8'd126
//ChickenCat Sreens
`define sChickenCat5Start1 8'd139 
`define sChickenCat5Start2 8'd140 
`define sChickenCat5 8'd141
`define sChickenCat6Start1 8'd142 
`define sChickenCat6Start2 8'd142 
`define sChickenCat6 8'd143
`define sChickenCat7Start1 8'd144 
`define sChickenCat7Start2 8'd145 
`define sChickenCat7 8'd146
`define sChickenCat8Start1 8'd147 
`define sChickenCat8Start2 8'd148 
`define sChickenCat8 8'd149
`define sChickenCat9Start1 8'd150 
`define sChickenCat9Start2 8'd151 
`define sChickenCat9 8'd152
//ChickenDog Sreens
`define sChickenDog5Start1 8'd165 
`define sChickenDog5Start2 8'd166 
`define sChickenDog5 8'd167
`define sChickenDog6Start1 8'd168 
`define sChickenDog6Start2 8'd169 
`define sChickenDog6 8'd170
`define sChickenDog7Start1 8'd171 
`define sChickenDog7Start2 8'd172 
`define sChickenDog7 8'd173
`define sChickenDog8Start1 8'd174 
`define sChickenDog8Start2 8'd175 
`define sChickenDog8 8'd176
`define sChickenDog9Start1 8'd177 
`define sChickenDog9Start2 8'd178 
`define sChickenDog9 8'd179
//CatCat Sreens
`define sCatCat1Start 8'd180 
`define sCatCat1 8'd182
`define sCatCat2Start 8'd183 
`define sCatCat2 8'd185
`define sCatCat3Start 8'd186 
`define sCatCat3 8'd188
`define sCatCat4Start 8'd189 
`define sCatCat4 8'd191
`define sCatCat5Start 8'd192 
`define sCatCat5 8'd194
`define sCatCat6Start 8'd195 
`define sCatCat6 8'd197
//DogDog Sreens
`define sDogDog1 8'd200
`define sDogDog2Start 8'd201 
`define sDogDog2 8'd203
`define sDogDog3Start 8'd204 
`define sDogDog3 8'd206
`define sDogDog4Start 8'd207 
`define sDogDog4 8'd209
`define sDogDog5Start 8'd210 
`define sDogDog5 8'd212
`define sDogDog6Start 8'd213 
`define sDogDog6 8'd215
//ChickenChicken Sreens
`define sChickenChicken1Start 8'd216 
`define sChickenChicken1 8'd218
`define sChickenChicken2Start 8'd219 
`define sChickenChicken2 8'd221
`define sChickenChicken3Start 8'd222 
`define sChickenChicken3 8'd224
`define sChickenChicken4Start 8'd225 
`define sChickenChicken4 8'd227
`define sChickenChicken5Start 8'd228 
`define sChickenChicken5 8'd230 
`define sChickenChicken6Start 8'd231 
`define sChickenChicken6 8'd233
//Player 1 Wins 
`define sP1Wins1Start1 8'd234 
`define sP1Wins1Start2 8'd235
`define sP1Wins1 8'd236
`define sP1Wins2Start1 8'd237
`define sP1Wins2Start2 8'd238
`define sP1Wins2 8'd239
//Player 2 Wins 
`define sP2Wins1Start1 8'd240
`define sP2Wins1Start2 8'd241
`define sP2Wins1 8'd242
`define sP2Wins2Start1 8'd243
`define sP2Wins2Start2 8'd244
`define sP2Wins2 8'd245
//Scenario
`define sScenario 8'd246

//Delay Signal
delaySignal delay1(.clk(clk), .delaySignalReset(delaySignalReset), .signal(delay)); //delays signal so it goes at 4Hz

//STATE ASSIGNMENTS
//Update state on clock; if reset, goes to state with 5'b00000 which is the first state
	DFlipFlop #(8) stateReg(clk, nextState, currentState, stateReset);

	always @(*) begin
		case(currentState)
			//Start Screen of game
			`s0: nextState = `sTitle1Start1; //reset everything to 0

			//Title Screen moves to Choose screen when user presses KEY[1]
			`sTitle1Start1: nextState = `sTitle1Start2; //Loading xInitial and yInitial Values 
			`sTitle1Start2: nextState = `sTitle1; //Loading x Values and yValues
			`sTitle1: nextState = userCont? `sChoose1Start : (delay? `sTitle2Start1: `sTitle1); //Clock keeps updating

			`sTitle2Start1: nextState = `sTitle2Start2; 
			`sTitle2Start2: nextState = `sTitle2; 
			`sTitle2: nextState = userCont? `sChoose1Start : (delay? `sTitle3Start1: `sTitle2); 

			`sTitle3Start1: nextState = `sTitle3Start2; 
			`sTitle3Start2: nextState = `sTitle3; 
			`sTitle3: nextState = userCont? `sChoose1Start : (delay? `sTitle1Start1: `sTitle3); 

			//Title Screen moves to Choose screen when user presses KEY[1]
			`sChoose1Start: nextState = `sChoose1; //Loading xInitial and yInitial Values 
			`sChoose1: nextState = userChoose? `sScenario : (delay? `sChoose2Start: `sChoose1); //Clock keeps updating

			`sChoose2Start: nextState = `sChoose2; 
			`sChoose2: nextState = userChoose? `sScenario : (delay? `sChoose3Start: `sChoose2); 

			`sChoose3Start: nextState = `sChoose3; 
			`sChoose3: nextState = userChoose? `sScenario : (delay? `sChoose1Start: `sChoose3); 
			
			//Default if it doesnt specify is Cat Cat Scenario
			`sScenario: nextState = catCat? `sCatCat5Start1: (catDog? `sCatDog5Start1: (catChicken? `sCatChicken5Start1: (chickenCat? `sChickenCat5Start1: (chickenDog? `sChickenDog5Start1: (chickenChicken? `sChickenChicken1Start: (dogCat? `sDogCat5Start1: (dogDog? `sDogDog1Start1: (dogChicken? `sDogChicken5Start1: `sCatCat5Start1))))))));

			//Cat Dog
			`sCatDog5Start1: nextState = `sCatDog5Start2;
			`sCatDog5Start2: nextState = `sCatDog5;
			`sCatDog5: nextState = delay? `sCatDog6Start1: `sCatDog5;

			`sCatDog6Start1: nextState = `sCatDog6Start2;
			`sCatDog6Start2: nextState = `sCatDog6;
			`sCatDog6: nextState = delay? `sCatDog7Start1: `sCatDog6;

			`sCatDog7Start1: nextState = `sCatDog7Start2;
			`sCatDog7Start2: nextState = `sCatDog7;
			`sCatDog7: nextState = delay? `sCatDog8Start1: `sCatDog7;

			`sCatDog8Start1: nextState = `sCatDog8Start2;
			`sCatDog8Start2: nextState = `sCatDog8;
			`sCatDog8: nextState = delay? `sCatDog9Start1: `sCatDog8;

			`sCatDog9Start1: nextState = `sCatDog9Start2;
			`sCatDog9Start2: nextState = `sCatDog9;
			`sCatDog9: nextState = delay? (player1Wins? `sP1Wins1Start1 :(player2Wins? `sP2Wins1Start1: `sChoose1Start)): `sCatDog9;

//Cat CHicken
			`sCatChicken5Start1: nextState = `sCatChicken5Start2;
			`sCatChicken5Start2: nextState = `sCatChicken5;
			`sCatChicken5: nextState = delay? `sCatChicken6Start1: `sCatChicken5;

			`sCatChicken6Start1: nextState = `sCatChicken6Start2;
			`sCatChicken6Start2: nextState = `sCatChicken6;
			`sCatChicken6: nextState = delay? `sCatChicken7Start1: `sCatChicken6;

			`sCatChicken7Start1: nextState = `sCatChicken7Start2;
			`sCatChicken7Start2: nextState = `sCatChicken7;
			`sCatChicken7: nextState = delay? `sCatChicken8Start1: `sCatChicken7;

			`sCatChicken8Start1: nextState = `sCatChicken8Start2;
			`sCatChicken8Start2: nextState = `sCatChicken8;
			`sCatChicken8: nextState = delay? `sCatChicken9Start1: `sCatChicken8;

			`sCatChicken9Start1: nextState = `sCatChicken9Start2;
			`sCatChicken9Start2: nextState = `sCatChicken9;
			`sCatChicken9: nextState = delay? (player1Wins? `sP1Wins1Start1 :(player2Wins? `sP2Wins1Start1: `sChoose1Start)): `sCatChicken9;

			//ChickenCat Scenario
			`sChickenCat5Start1: nextState = `sChickenCat5Start2;
			`sChickenCat5Start2: nextState = `sChickenCat5;
			`sChickenCat5: nextState = delay? `sChickenCat6Start1: `sChickenCat5;

			`sChickenCat6Start1: nextState = `sChickenCat6Start2;
			`sChickenCat6Start2: nextState = `sChickenCat6;
			`sChickenCat6: nextState = delay? `sChickenCat7Start1: `sChickenCat6;

			`sChickenCat7Start1: nextState = `sChickenCat7Start2;
			`sChickenCat7Start2: nextState = `sChickenCat7;
			`sChickenCat7: nextState = delay? `sChickenCat8Start1: `sChickenCat7;

			`sChickenCat8Start1: nextState = `sChickenCat8Start2;
			`sChickenCat8Start2: nextState = `sChickenCat8;
			`sChickenCat8: nextState = delay? `sChickenCat9Start1: `sChickenCat8;

			`sChickenCat9Start1: nextState = `sChickenCat9Start2;
			`sChickenCat9Start2: nextState = `sChickenCat9;
			`sChickenCat9: nextState = delay?  (player1Wins? `sP1Wins1Start1 :(player2Wins? `sP2Wins1Start1: `sChoose1Start)): `sChickenCat9;

			//ChickenDog Scenario
			`sChickenDog5Start1: nextState = `sChickenDog5Start2;
			`sChickenDog5Start2: nextState = `sChickenDog5;
			`sChickenDog5: nextState = delay? `sChickenDog6Start1: `sChickenDog5;

			`sChickenDog6Start1: nextState = `sChickenDog6Start2;
			`sChickenDog6Start2: nextState = `sChickenDog6;
			`sChickenDog6: nextState = delay? `sChickenDog7Start1: `sChickenDog6;

			`sChickenDog7Start1: nextState = `sChickenDog7Start2;
			`sChickenDog7Start2: nextState = `sChickenDog7;
			`sChickenDog7: nextState = delay? `sChickenDog8Start1: `sChickenDog7;

			`sChickenDog8Start1: nextState = `sChickenDog8Start2;
			`sChickenDog8Start2: nextState = `sChickenDog8;
			`sChickenDog8: nextState = delay? `sChickenDog9Start1: `sChickenDog8;

			`sChickenDog9Start1: nextState = `sChickenDog9Start2;
			`sChickenDog9Start2: nextState = `sChickenDog9;
			`sChickenDog9: nextState = delay?  (player1Wins? `sP1Wins1Start1 :(player2Wins? `sP2Wins1Start1: `sChoose1Start)): `sChickenDog9;

			//DogCat Scenario
			`sDogCat5Start1: nextState = `sDogCat5Start2;
			`sDogCat5Start2: nextState = `sDogCat5;
			`sDogCat5: nextState = delay? `sDogCat6Start1: `sDogCat5;

			`sDogCat6Start1: nextState = `sDogCat6Start2;
			`sDogCat6Start2: nextState = `sDogCat6;
			`sDogCat6: nextState = delay? `sDogCat7Start1: `sDogCat6;

			`sDogCat7Start1: nextState = `sDogCat7Start2;
			`sDogCat7Start2: nextState = `sDogCat7;
			`sDogCat7: nextState = delay? `sDogCat8Start1: `sDogCat7;

			`sDogCat8Start1: nextState = `sDogCat8Start2;
			`sDogCat8Start2: nextState = `sDogCat8;
			`sDogCat8: nextState = delay? `sDogCat9Start1: `sDogCat8;

			`sDogCat9Start1: nextState = `sDogCat9Start2;
			`sDogCat9Start2: nextState = `sDogCat9;
			`sDogCat9: nextState = delay?  (player1Wins? `sP1Wins1Start1 :(player2Wins? `sP2Wins1Start1: `sChoose1Start)): `sDogCat9;

			//DogChicken Scenario
			`sDogChicken4Start1: nextState = `sDogChicken4Start2;
			`sDogChicken4Start2: nextState = `sDogChicken4;
			`sDogChicken4: nextState = delay? `sDogChicken5Start1: `sDogChicken4;

			`sDogChicken5Start1: nextState = `sDogChicken5Start2;
			`sDogChicken5Start2: nextState = `sDogChicken5;
			`sDogChicken5: nextState = delay? `sDogChicken6Start1: `sDogChicken5;

			`sDogChicken6Start1: nextState = `sDogChicken6Start2;
			`sDogChicken6Start2: nextState = `sDogChicken6;
			`sDogChicken6: nextState = delay? `sDogChicken7Start1: `sDogChicken6;

			`sDogChicken7Start1: nextState = `sDogChicken7Start2;
			`sDogChicken7Start2: nextState = `sDogChicken7;
			`sDogChicken7: nextState = delay? `sDogChicken8Start1: `sDogChicken7;

			`sDogChicken8Start1: nextState = `sDogChicken8Start2;
			`sDogChicken8Start2: nextState = `sDogChicken8;
			`sDogChicken8: nextState = delay? `sDogChicken9Start1: `sDogChicken8;

			`sDogChicken9Start1: nextState = `sDogChicken9Start2;
			`sDogChicken9Start2: nextState = `sDogChicken9;
			`sDogChicken9: nextState = delay?  (player1Wins? `sP1Wins1Start1 :(player2Wins? `sP2Wins1Start1: `sChoose1Start)): `sDogChicken9;

			//CatCat Scenario
			`sCatCat1Start: nextState = `sCatCat1;
			`sCatCat1: nextState = delay? `sCatCat2Start: `sCatCat1;

			`sCatCat2Start: nextState = `sCatCat2;
			`sCatCat2: nextState = delay? `sCatCat3Start: `sCatCat2;

			`sCatCat3Start: nextState = `sCatCat3;
			`sCatCat3: nextState = delay? `sCatCat4Start: `sCatCat3;

			`sCatCat4Start: nextState = `sCatCat4;
			`sCatCat4: nextState = delay? `sCatCat5Start: `sCatCat4;

			`sCatCat5Start: nextState = `sCatCat5;
			`sCatCat5: nextState = delay? `sCatCat6Start: `sCatCat5;

			`sCatCat6Start: nextState = `sCatCat6;
			`sCatCat6: nextState = delay? `sChoose1Start: `sCatCat6;

			//DogDog Scenario
			`sDogDog1Start: nextState = `sDogDog1;
			`sDogDog1: nextState = delay? `sDogDog2Start: `sDogDog1;

			`sDogDog2Start: nextState = `sDogDog2;
			`sDogDog2: nextState = delay? `sDogDog3Start: `sDogDog2;

			`sDogDog3Start: nextState = `sDogDog3;
			`sDogDog3: nextState = delay? `sDogDog4Start: `sDogDog3;

			`sDogDog4Start: nextState = `sDogDog4;
			`sDogDog4: nextState = delay? `sDogDog5Start: `sDogDog4;

			`sDogDog5Start: nextState = `sDogDog5;
			`sDogDog5: nextState = delay? `sDogDog6Start: `sDogDog5;

			`sDogDog6Start: nextState = `sDogDog6;
			`sDogDog6: nextState = delay? `sChoose1Start: `sDogDog6;

			//ChickenChicken Scenario
			`sChickenChicken1Start: nextState = `sChickenChicken1;
			`sChickenChicken1: nextState = delay? `sChickenChicken2Start: `sChickenChicken1;

			`sChickenChicken2Start: nextState = `sChickenChicken2;
			`sChickenChicken2: nextState = delay? `sChickenChicken3Start: `sChickenChicken2;

			`sChickenChicken3Start: nextState = `sChickenChicken3;
			`sChickenChicken3: nextState = delay? `sChickenChicken4Start: `sChickenChicken3;

			`sChickenChicken4Start: nextState = `sChickenChicken4;
			`sChickenChicken4: nextState = delay? `sChickenChicken5Start: `sChickenChicken4;

			`sChickenChicken5Start: nextState = `sChickenChicken5;
			`sChickenChicken5: nextState = delay? `sChickenChicken6Start: `sChickenChicken5;

			`sChickenChicken6Start: nextState = `sChickenChicken6;
			`sChickenChicken6: nextState = delay? `sChoose1Start: `sChickenChicken6;

			//P1Wins
			`sP1Wins1Start1: nextState = `sP1Wins1Start2; 
			`sP1Wins1Start2: nextState = `sP1Wins1; 
			`sP1Wins1: nextState = userResetGame? `sTitle1Start1 : (delay? `sP1Wins2Start1: `sP1Wins1); 

			`sP1Wins2Start1: nextState = `sP1Wins2Start2; 
			`sP1Wins2Start2: nextState = `sP1Wins2; 
			`sP1Wins2: nextState = userResetGame? `sTitle1Start1 : (delay? `sP1Wins1Start1: `sP1Wins2); 

			//P2Wins
			`sP2Wins1Start1: nextState = `sP2Wins1Start2; 
			`sP2Wins1Start2: nextState = `sP2Wins1; 
			`sP2Wins1: nextState = userResetGame? `sTitle1Start1 : (delay? `sP2Wins2Start1: `sP2Wins1); 

			`sP2Wins2Start1: nextState = `sP2Wins2Start2; 
			`sP2Wins2Start2: nextState = `sP2Wins2; 
			`sP2Wins2: nextState = userResetGame? `sTitle1Start1 : (delay? `sP2Wins1Start1: `sP2Wins2); 

			default: nextState = `s0; //The moment the program starts, go to first state where everything gets reset
			endcase
		end

		always @(*) begin
			case(currentState)
				`s0: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b1; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b1; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd0;
				//Player Updating Registers
				playerReset = 1'b1; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;

			end
			`sTitle1Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd0;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		`sTitle1Start2: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd0;
				//Player Updating Registers
				playerReset = 1'b1; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end

		`sTitle1: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd0;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end
		
		`sTitle2Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd1;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sTitle2Start2: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd1;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		`sTitle2: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd1;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end
		`sTitle3Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd2;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sTitle3Start2: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd2;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		`sTitle3: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd2;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end
		
	
		`sChoose1Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd3;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		`sChoose1: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd3;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChoose2Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd4;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		`sChoose2: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd4;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChoose3Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd5;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		`sChoose3: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd5;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end
//Scenario -> Just put all signals to 0
		`sScenario: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd0;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
//Cat Dog
		`sCatDog5Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd17;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b1;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatDog5Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b1;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatDog5: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatDog6Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd18;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatDog6Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatDog6: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatDog7Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd19;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatDog7Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatDog7: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatDog8Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd20;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatDog8Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatDog8: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatDog9Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatDog9Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatDog9: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatChicken5Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd26;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b1;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatChicken5Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b1;  
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatChicken5: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatChicken6Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd27;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatChicken6Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatChicken6: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatChicken7Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd28;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatChicken7Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatChicken7: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end


		`sCatChicken8Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd29;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatChicken8Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatChicken8: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sCatChicken9Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd30;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatChicken9Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sCatChicken9: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenCat5Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd35;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b1;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenCat5Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b1;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenCat5: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenCat6Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd36;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenCat6Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenCat6: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenCat7Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd37;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenCat7Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenCat7: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenCat8Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd38;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenCat8Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenCat8: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenCat9Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd39;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenCat9Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenCat9: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

//CHICKEN DOG
		`sChickenDog5Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd47;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b1;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenDog5Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b1;  
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenDog5: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenDog6Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd48;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenDog6Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenDog6: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenDog7Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd49;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenDog7Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenDog7: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end


		`sChickenDog8Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd50;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenDog8Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenDog8: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sChickenDog9Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd51;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenDog9Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sChickenDog9: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

//DOG CAT
		`sDogCat5Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd56;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b1;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogCat5Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b1;  
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogCat5: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogCat6Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd57;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogCat6Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogCat6: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogCat7Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd58;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogCat7Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogCat7: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogCat8Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd59;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogCat8Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogCat8: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogCat9Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd60;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogCat9Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogCat9: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

//DOG CHICKEN
		`sDogChicken5Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd65;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b1;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogChicken5Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b1;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogChicken5: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				///Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogChicken6Start1: begin 

				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd66;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogChicken6Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogChicken6: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogChicken7Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd67;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogChicken7Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogChicken7: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end


		`sDogChicken8Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd68;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogChicken8Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogChicken8: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

		`sDogChicken9Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd69;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogChicken9Start2: begin 

				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end
		`sDogChicken9: begin

				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end


//START OF TIES

//Chicken Chicken
		`sChickenChicken1Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd41;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenChicken1: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd41;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end

		`sChickenChicken2Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd42;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenChicken2: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd42;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sChickenChicken3Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd41;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenChicken3: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd41;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sChickenChicken4Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd42;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenChicken4: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd42;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sChickenChicken5Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd41;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenChicken5: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd41;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sChickenChicken6Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd42;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sChickenChicken6: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd42;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end




//Dog Dog
		`sDogDog1Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogDog1: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end

		`sDogDog2Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd22;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogDog2: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd22;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sDogDog3Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogDog3: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sDogDog4Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd22;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogDog4: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd22;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sDogDog5Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogDog5: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd21;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sDogDog6Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd22;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sDogDog6: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd22;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end




//Cat Cat
		`sCatCat1Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd11;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatCat1: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd11;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end

		`sCatCat2Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd12;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatCat2: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd12;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sCatCat3Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd11;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatCat3: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd11;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end

	
		`sCatCat4Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd12;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatCat4: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd12;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sCatCat5Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd11;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatCat5: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd11;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;

		end


		`sCatCat6Start: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 7'd12;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sCatCat6: begin
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 7'd12;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; 
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

//START OF FINAL WINNING SCREENS

		`sP1Wins1Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd6;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sP1Wins1Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end

		`sP1Wins1: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;		
				
		end

		`sP1Wins2Start1: begin 
			//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd7;
				//Player Updating Registers
			playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
			addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sP1Wins2Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1;
		end
		
		`sP1Wins2: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
			addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end
		
		
		`sP2Wins1Start1: begin 
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd6;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sP2Wins1Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; 
		end

		`sP2Wins1: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;		
				
		end

		`sP2Wins2Start1: begin 
			//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b0;
				//Color Register
				black = 1'b0; memorySel = 7'd7;
				//Player Updating Registers
			playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0;  
				//Delaying internal signals
				delaySignalReset = 1'b1; 
				//Counting for screens (160x120)
			addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
		end
		
		`sP2Wins2Start2: begin 
				//x and y vga Coordinate Registers
				xLoad = 1'b1; yLoad = 1'b1;
				//Delaying internal signals
				delaySignalReset = 1'b0; 
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1;
		end
		
		`sP2Wins2: begin
				xCountUp = 1'b1; xLoad = 1'b1; yCountUp = 1'b1; yLoad = 1'b1; xySel = 2'b01;
				//Counting for screens (160x120)
			addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
		end

	endcase
end
endmodule

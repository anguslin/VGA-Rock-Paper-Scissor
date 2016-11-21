
module controller(clk, userCont, dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken, xInitReset, xInitLoad, yInitReset, yInitLoad, xCountUp, xReset, xLoad, yCountUp, yReset, yLoad, xySel, black, playerReset, winner1, winner2, playerLoad, addressScreenCounterReset, screenCountLoad, addressSpriteCounterReset, spriteCountLoad, yInitSel, xInitSel, memorySel, plot, scenarioLoad, stateReset, screenDone);

//Signals controled by user inputs
input clk, userCont, stateReset; 
//Signals controlled by internal datapath
input dogDog, dogCat, dogChicken, catDog, catCat, catChicken, chickenDog, chickenCat, chickenChicken;
//Output to datapath
output reg xInitReset, xInitLoad, yInitReset, yInitLoad, xCountUp, xReset, xLoad, yCountUp, yReset, yLoad, black, playerReset, winner1, winner2, playerLoad, addressScreenCounterReset, screenCountLoad, addressSpriteCounterReset, spriteCountLoad, plot, scenarioLoad;

output reg [1:0] yInitSel, xySel;
output reg [3:0] xInitSel; 
output reg [4:0] memorySel;

//Signal to wait
wire delay;
reg delaySignalReset;

//Signal stating when screen is done being drawn
wire screenDone;

//States
reg [6:0] nextState;
wire [6:0] currentState;

//Reset everything state
`define s0 7'd0

//Title Screen
`define sTitle1Start1 7'd1
`define sTitle1Start2 7'd2
//`define sTitle1Start3 7'd30
`define sTitle2Start1 7'd3
`define sTitle2Start2 7'd4
`define sTitle3Start1 7'd5
`define sTitle3Start2 7'd6
`define sTitle1 7'd7
`define sTitle2 7'd8
`define sTitle3 7'd9
//Choose Screen
`define sChoose1Start 7'd10 
`define sChoose2Start 7'd11
`define sChoose3Start 7'd12
`define sChoose1 7'd13
`define sChoose2 7'd14
`define sChoose3 7'd15
//Determine which of the 9 Scenarios was chosen
`define sScenario 7'd16

`define s2 7'd17  
`define s3a 7'd18
`define s3b 7'd19
`define s3c 7'd20
`define s3d 7'd21
`define s3e 7'd22
`define s3f 7'd23
`define s3g 7'd24
`define s3h 7'd25
`define s3i 7'd26
`define s4  7'd27
`define s5a 7'd28
`define s5b 7'd29

//Delay Signal
delaySignal delay1(.clk(clk), .delaySignalReset(delaySignalReset), .signal(delay)); //delays signal so it goes at 4Hz

//STATE ASSIGNMENTS
//Update state on clock; if reset, goes to state with 5'b00000 which is the first state
	DFlipFlop #(5) (clk, nextState, currentState, stateReset);

	always @(*) begin
		case(currentState)
			//Start Screen of game
			`s0: nextState = `sTitle1Start1; //reset everything to 0

			//Title Screen moves to Choose screen when user presses KEY[1]

			`sTitle1Start1: nextState = `sTitle1Start2; //Loading xInitial and yInitial Values 
			`sTitle1Start2: nextState = `sTitle1; //Loading x Values and yValues
			//`sTitle1Start3: nextState = `sTitle1; //Loading x Values and yValues
			`sTitle1: nextState = userCont? `sChoose1Start : (delay? `sTitle2Start1: `sTitle1); //Clock keeps updating

			`sTitle2Start1: nextState = `sTitle2Start2; 
			`sTitle2Start2: nextState = `sTitle2; 
			`sTitle2: nextState = userCont? `sChoose1Start : (delay? `sTitle3Start1: `sTitle2); 

			`sTitle3Start1: nextState = `sTitle3Start2; 
			`sTitle3Start2: nextState = `sTitle3; 
			`sTitle3: nextState = userCont? `sChoose1Start : (delay? `sTitle1Start1: `sTitle3); 

//			//Choose Screen moves to Deciding State when user presses KEY[1]
//			`sChoose1Start: nextState = `sChoose1; //Resets the title counts and sets everything up to begin counting
//			`sChoose1: nextState = userCont? `sScenario : (delay? `sChoose2Start: `sChoose1); //Clock keeps updating
//
//			`sChoose2Start: nextState = `sTitle2; //Resets the title counts and sets everything up to begin counting
//			`sChoose2: nextState = userCont? `sScenario : (delay? `sChoose3Start: `sChoose2); //Clock keeps updating
//
//			`sChoose3Start: nextState = `sTitle3; //Resets the title counts and sets everything up to begin counting
//			`sChoose3: nextState = userCont? `sScenario : (delay? `sChoose1Start: `sChoose3); //Clock keeps updating
//
//			//Wait for players to choose characters
//			`s1: nextState = userCont2? `s2: currentState; //user controls next state
//
//			//Depending on which combination of inputs the players choose
//			`s2: begin //Internal signals decide next state
//			if(cont1a)
//				nextState = `s3a;
//			else if(cont1b) 
//				nextState = `s3b; 
//			else if(cont1c) 
//				nextState = `s3c;
//			else if(cont1d) 
//				nextState = `s3d;
//			else if(cont1e)
//				nextState = `s3e; 
//			else if(cont1f) 
//				nextState = `s3f;
//			else if(cont1g)
//				nextState = `s3g;
//			else if(cont1h)
//				nextState = `s3h;
//			else if(cont1i)
//				nextState = `s3i;
//			else
//				nextState = currentState; 
//		end
//
//		//Check if one of the players have 3 points, which = winner                                    
//			`s3a: nextState = cont2? `s4: `s1; //Internal signals decide next state
//			`s3b: nextState = cont2? `s4: `s1; 
//			`s3c: nextState = cont2? `s4: `s1; 
//			`s3d: nextState = cont2? `s4: `s1; 
//			`s3e: nextState = cont2? `s4: `s1; 
//			`s3f: nextState = cont2? `s4: `s1; 
//			`s3g: nextState = cont2? `s4: `s1; 
//			`s3h: nextState = cont2? `s4: `s1; 
//			`s3i: nextState = cont2? `s4: `s1; 
//
//			//Checks which player won 5a = player 1, 5b = player 2
//			`s4: nextState = cont3? `s5a: `s5b; //Internal signals decide next state
//
//			//Wait for users to restart the game, otherwise, display the winning screen
//			`s5a: nextState = userCont3? `s0: currentState; //user controls next state
//			`s5b: nextState = userCont3? `s0: currentState; //user controls next state
//

			//Start with Loading Dog
			`sCatDog1: nextState = `sCatDog2;
			`sCatDog2: nextState = `sCatDog;
			`sCatDog3: nextState = screenDone? `sCatDog4: `sCatDog3;
			//Start Loading Cat
			`sCatDog4: nextState = `sCatDog5;
			`sCatDog5: nextState = `sCatDog;
			`sCatDog: nextState = delay? `sBlackScreen1: `sCatDog;
//Clears Screen and redraws cat and dog in correct posiiton

			`sBlackScreen1: nextState = `sBlackScreen2;
			`sBlackScreen2: nextState = `sBlackScreen;

//			`sBlackScreen: begin
//				if(catDogSignal)
//					nextState = `sCatDog1;
//				else if(catDogSignal1)
//					nextState = `sCatDogA1;
//				else if(catDogSignal2)
//					`nextState = `sCatDogB1;
//				else if(catDogSignal
//					`nextState = `sCatDogC1;
//				else if(catDogSignal2)
//					nextState = ``sCatDogD1;
//				else if(catDogSignal2)
//					`nextState = `sCatDogE1;
//				else if(catDogSignal2)
//					`nextState = `sCatDogF1;
//				else if(catDogSignal2)
//					`nextState = `sCatDogG1;
//				else if(catDogSignal2)
//					`nextState = `sCatDogH1;
			end



			default: nextState = `s0; //The moment the program starts, go to first state where everything gets reset
			endcase
		end

		always @(*) begin
			case(currentState)
				`s0: begin 
				//Inital xy registers
				xInitReset = 1'b1; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b1; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b1; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b1; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b1; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b1;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b1; spriteCountLoad = 1'b0;
				//PA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;

			end
			`sTitle1Start1: begin 
			//Loading the x and y inital coordinates -> xInitLoad, yInitLoad, xInitSel, yInitSel
			//Start the delay signal counting

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b1; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b1;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b1;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b1;
		end
		`sTitle1Start2: begin 
		//Loading the inital coordinates into x and y before starting to count -> xLoad, yLoad, xySel
		//Also make sure Screen Counter is at 0 -> AddressscreenCounterReset

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end

		`sTitle1: begin
//Go into a loop of loading the values of the respective ROM color until it finishes loading -> memorySel, xCountUp, xLoad, yCountUp, yLoad, addressScreenCountLoad

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b0; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b1;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end

		//Loading Dog on the right side
`sCatDog1: begin 
			//Loading the x and y inital coordinates -> xInitLoad, yInitLoad, xInitSel, yInitSel
			//Start the delay signal counting

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b1000; xInitLoad = 1'b1; yInitReset = 1'b0; yInitSel = 2'b10; yInitLoad = 1'b1;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b10001;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b1;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end
		`sCatDog2: begin 
		//Loading the inital coordinates into x and y before starting to count -> xLoad, yLoad, xySel
		//Also make sure Screen Counter is at 0 -> AddressscreenCounterReset

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b10001;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b1; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end
		`sCatDog3: begin
//Go into a loop of loading the values of the respective ROM color until it finishes loading -> memorySel, xCountUp, xLoad, yCountUp, yLoad, addressScreenCountLoad

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b10;
				//Color Register
				black = 1'b0; memorySel = 5'b10001;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
				//Loading the Scenario
				scenarioLoad = 1'b0; 

//Loading Cat on the Left Side
`sCatDog4: begin 
			//Loading the x and y inital coordinates -> xInitLoad, yInitLoad, xInitSel, yInitSel
			//Start the delay signal counting

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0001; xInitLoad = 1'b1; yInitReset = 1'b0; yInitSel = 2'b10; yInitLoad = 1'b1;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b10100;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b1;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end
		`sCatDog5: begin 
		//Loading the inital coordinates into x and y before starting to count -> xLoad, yLoad, xySel
		//Also make sure Screen Counter is at 0 -> AddressscreenCounterReset

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b0; memorySel = 5'b10100;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b1; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end
		`sCatDog: begin
//Go into a loop of loading the values of the respective ROM color until it finishes loading -> memorySel, xCountUp, xLoad, yCountUp, yLoad, addressScreenCountLoad

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b10;
				//Color Register
				black = 1'b0; memorySel = 5'b10100;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b1;
				//Plotting for VGA
				plot = 1'b1;
				//Loading the Scenario
				scenarioLoad = 1'b0; 

		end

		`sBlackScreen1: begin 
			//Loading the x and y inital coordinates -> xInitLoad, yInitLoad, xInitSel, yInitSel
			//Start the delay signal counting

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b1; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b1;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b0; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b0; xySel = 2'b00;
				//Color Register
				black = 1'b1; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end
		`sBlackScreen2: begin 
		//Loading the inital coordinates into x and y before starting to count -> xLoad, yLoad, xySel
		//Also make sure Screen Counter is at 0 -> AddressscreenCounterReset

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b0; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b0; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b00;
				//Color Register
				black = 1'b1; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0;  winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b1; screenCountLoad = 1'b0;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b0;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end
		`sBlackScreen: begin
//Go into a loop of loading the values of the respective ROM color until it finishes loading -> memorySel, xCountUp, xLoad, yCountUp, yLoad, addressScreenCountLoad

				//Inital xy registers
				xInitReset = 1'b0; xInitSel = 4'b0000; xInitLoad = 1'b0; yInitReset = 1'b0; yInitSel = 2'b00; yInitLoad = 1'b0;
				//x and y vga Coordinate Registers
				xCountUp = 1'b1; xReset = 1'b0; xLoad = 1'b1; yCountUp = 1'b1; yReset = 1'b0; yLoad = 1'b1; xySel = 2'b01;
				//Color Register
				black = 1'b1; memorySel = 5'b00000;
				//Player Updating Registers
				playerReset = 1'b0; winner1 = 1'b0; winner2 = 1'b0; playerLoad = 1'b0;
				//Delaying internal signals
				delaySignalReset = 1'b0;
				//Counting for screens (160x120)
				addressScreenCounterReset = 1'b0; screenCountLoad = 1'b1;
				//Counting fir sprites (40x40)
				addressSpriteCounterReset = 1'b0; spriteCountLoad = 1'b0;
				//Plotting for VGA
				plot = 1'b1;
				//Loading the Scenario
				scenarioLoad = 1'b0;
		end


	endcase
end

endmodule

// Copyright (c) 2019 Johannes Delport
// This code is licensed under MIT license (see LICENSE for details)
#ifndef J_ERRORS_H_
#define J_ERRORS_H_
#include "j_std_include.h"

#define DEF_ERROR 0
#define DEF_FILE_ERROR 1
#define LOG_ERROR 2
#define LOG_FILE_ERROR 3
#define OUTPUT_ERROR 4
#define OUTPUT_FILE_ERROR 5
#define INPUT_ERROR 6
#define INPUT_FILE_ERROR 7
#define UNKNOWN_SWITCH 8
#define CANNOT_OPEN_FILE 9
#define OUTPUT_LEGACY_ERROR 10
#define OUTPUT_LEGACY_FILE_ERROR 11
#define TOO_FEW_ARGUMENTS 12
#define NO_PLOT_COMPILE 13
#define FINAL_ARG_SWITCH 14
#define INVALID_ANALYSIS 15
#define INVALID_CONVENTION 16

#define CAP_ERROR 0
#define IND_ERROR 1
#define RES_ERROR 2
#define JJ_ERROR 3
#define KMUT_ERROR 4
#define IS_ERROR 5
#define VS_ERROR 6
#define TRL_ERROR 7
#define LABEL_ERROR 8
#define MISSING_LABEL 9
#define MISSING_PNODE 10
#define MISSING_NNODE 11
#define MISSING_JJMODEL 12
#define MODEL_NOT_DEFINED 13
#define MODEL_AREA_NOT_GIVEN 14
#define DUPLICATE_LABEL 15
#define INVALID_SUBCIRCUIT_NODES 16
#define TIME_ERROR 17
#define MISSING_SUBCIRCUIT_NAME 18
#define MUT_ERROR 19
#define INVALID_EXPR 20
#define INVALID_TX_DEFINED 21
#define MISSING_INDUCTOR 22

#define TRANS_ERROR 0
#define PRINT_ERROR 1
#define PLOT_ERROR 2
#define INV_CONTROL 3
#define DC_ERROR 4
#define AC_ERROR 5
#define PHASE_ERROR 6
#define NO_SIM 7

#define PARAM_TYPE_ERROR 0
#define UNKNOWN_MODEL_TYPE 1
#define BAD_MODEL_DEFINITION 2

#define NON_SQUARE 0

#define STOD_ERROR 0

#define INITIAL_VALUES 0
#define TOO_FEW_TIMESTEPS 1
#define TOO_FEW_VALUES 2
#define INITIAL_PULSE_VALUE 3
#define PULSE_TOO_FEW_ARGUMENTS 4
#define PULSE_VPEAK_ZERO 5
#define PULSE_RISE_TIME_ZERO 6
#define PULSE_FALL_TIME_ZERO 7
#define PULSE_WIDTH_ZERO 8
#define PULSE_REPEAT 9
#define SIN_TOO_FEW_ARGUMENTS 10
#define SIN_TOO_MANY_ARGUMENTS 11
#define SIN_VA_ZERO 12
#define CUS_TOO_FEW_ARGUMENTS 13
#define CUS_TOO_MANY_ARGUMENTS 14
#define CUS_SF_ZERO 15
#define CUS_WF_NOT_FOUND 16

#define JJCAP_NOT_FOUND 0
#define JJICRIT_NOT_FOUND 1
#define JJPHASE_NODE_NOT_FOUND 2
#define INDUCTOR_CURRENT_NOT_FOUND 3
#define MATRIX_SINGULAR 4

#define NO_SUCH_PLOT_TYPE 0
#define NO_SUCH_DEVICE_FOUND 1
#define CURRENT_THROUGH_VOLTAGE_SOURCE 2
#define NO_SUCH_NODE_FOUND 3
#define TOO_MANY_NODES 4
#define BOTH_ZERO 5
#define VOLTAGE_IN_PHASE 6

#define EXPRESSION_ARLEADY_DEFINED 0
#define UNIDENTIFIED_PART 1
#define MISMATCHED_PARENTHESIS 2
#define INVALID_RPN 3

#define NO_TRANSIENT_ANALYSIS 0
#define NO_INPUT_SWEEP 1
#define SOURCE_NOT_IDENTIFIED 2
#define SWEEP_NOT_PWL 3

class Errors {
	public:

		static 
		void 
		error_handling(int errorCode, std::string whatPart = "");

		static 
		void 
		invalid_component_errors(int errorCode, std::string componentLabel);

		static 
		void 
		control_errors(int errorCode, std::string whatPart);

		[[noreturn]] static 
		void 
		model_errors(int errorCode, std::string whatPart);

		static 
		void 
		matrix_errors(int errorCode, std::string whatPart);

		[[noreturn]] static 
		void 
		misc_errors(int errorCode, std::string whatPart);

		static 
		void 
		function_errors(int errorCode, std::string whatPart);

		[[noreturn]] static 
		void 
		simulation_errors(int errorCode, std::string whatPart);

		static 
		void 
		plotting_errors(int errorCode, std::string whatPart);

		static 
		void 
		parsing_errors(int errorCode, std::string whatPart);

		static 
		void 
		iv_errors(int errorCode, std::string whatPart);
};
#endif
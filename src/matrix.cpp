#include "include/matrix.hpp"

std::map<std::string, std::map<std::string, double>> bMatrixConductanceMap;
std::map<std::string, std::map<std::string, std::string>> bMatrixNodeMap;
std::vector<matrix_element> mElements;
std::vector<std::string> rowNames, columnNames;
std::vector<std::vector<double> > csr_A_matrix(3);
std::map<std::string, std::vector<double>> sources;
/*
  Systematically create A matrix
*/
void matrix_A(InputFile & iFile) {
	create_A_matrix(iFile);
	if (rowNames.size() != columnNames.size()) matrix_errors(NON_SQUARE, columnNames.size() + "x" + rowNames.size());
	if (VERBOSE) std::cout << std::setw(35) << std::left << "A matrix dimentions: " << columnNames.size() << "\n\n";

}
/*
  Create the A matrix in Compressed Row Storage (CRS) format
*/
void create_A_matrix(InputFile& iFile) {
	std::string cName, rName, cNameP, rNameP, cNameN, rNameN;
	std::vector<std::string> devicetokens;
	std::string label, nodeP, nodeN;
	bool pGND, nGND;
	/* Subcircuit nodes yet to be implemented */
	for (auto i : iFile.subcircuitSegments) {
		for (auto j : i.second) {
			devicetokens = tokenize_space(j);
			try { label = devicetokens.at(0); }
			catch (const std::out_of_range) {
				invalid_component_errors(MISSING_LABEL, j);
			}
			try { nodeP = devicetokens.at(1); }
			catch (const std::out_of_range) {
				invalid_component_errors(MISSING_PNODE, j);
			}
			try { nodeP = devicetokens.at(2); }
			catch (const std::out_of_range) {
				invalid_component_errors(MISSING_NNODE, j);
			}
			if (j[0] == 'R') {
			}
			else if (j[0] == 'C') {
			}
			else if (j[0] == 'L') {
			}
			else if (j[0] == 'V') {
			}
			else if (j[0] == 'I') {
			}
			else if (j[0] == 'B') {
			}
		}
	}
	/* Main circuit node identification*/
	for (auto i : iFile.maincircuitSegment) {
		devicetokens = tokenize_space(i);
		double value = 0.0;
		/* Check if label exists, if not there is a bug in the program */
		try { label = devicetokens.at(0); }
		catch (const std::out_of_range) {
			invalid_component_errors(MISSING_LABEL, i);
		}
		/* Check if positive node exists, if not it's a bad device line definition */
		try { nodeP = devicetokens.at(1); }
		catch (const std::out_of_range) {
			invalid_component_errors(MISSING_PNODE, i);
		}
		/* Check if negative node exists, if not it's a bad device line definition */
		try { nodeN = devicetokens.at(2); }
		catch (const std::out_of_range) {
			invalid_component_errors(MISSING_NNODE, i);
		}
		if (i[0] == 'R') {
			/* Check if value exists, if not it's a bad resistor definition */
			try { value = modifier(devicetokens.at(3)); }
			catch (const std::out_of_range) {
				invalid_component_errors(RES_ERROR, i);
			}
			if (nodeP != "0" && nodeP.find("GND") == std::string::npos) {
				cNameP = "C_NV" + nodeP;
				rNameP = "R_N" + nodeP;
				unique_push(rowNames, rNameP);
				unique_push(columnNames, cNameP);
				bMatrixConductanceMap[rNameP][label] = 0.0;
				pGND = false;
			}
			else pGND = true;
			if (nodeN != "0" && nodeN.find("GND") == std::string::npos) {
				cNameN = "C_NV" + nodeN;
				rNameN = "R_N" + nodeN;
				unique_push(rowNames, rNameN);
				unique_push(columnNames, cNameN);
				bMatrixConductanceMap[rNameN][label] = 0.0;
				nGND = false;
			}
			else nGND = true;
			matrix_element e;
			if (!pGND) {
				/* Positive node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = 1 / value;
				mElements.push_back(e);
				if (!nGND) {
					/* Positive node row and negative node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = -1 / value;
					mElements.push_back(e);
					/* Negative node row and positive node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = -1 / value;
					mElements.push_back(e);
				}
			}
			if (!nGND) {
				/* Negative node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = 1 / value;
				mElements.push_back(e);
			}
		}
		else if (i[0] == 'C') {
			/* Check if value exists, if not it's a bad capactitor definition */
			try { value = modifier(devicetokens.at(3)); }
			catch (const std::out_of_range) {
				invalid_component_errors(CAP_ERROR, i);
			}
			if (nodeP != "0" && nodeP.find("GND") == std::string::npos) {
				cNameP = "C_NV" + nodeP;
				rNameP = "R_N" + nodeP;
				unique_push(rowNames, rNameP);
				unique_push(columnNames, cNameP);
				bMatrixConductanceMap[rNameP][label] = value;
				pGND = false;
			}
			else pGND = true;
			if (nodeN != "0" && nodeN.find("GND") == std::string::npos) {
				cNameN = "C_NV" + nodeN;
				rNameN = "R_N" + nodeN;
				unique_push(rowNames, rNameN);
				unique_push(columnNames, cNameN);
				bMatrixConductanceMap[rNameN][label] = -value;
				nGND = false;
			}
			else nGND = true;
			if (nGND) bMatrixNodeMap[rNameP][label + "-V"] = cNameP + "-GND";
			else if (pGND) bMatrixNodeMap[rNameN][label + "-V"] = "GND-" + cNameN;
			else {
				bMatrixNodeMap[rNameP][label + "-V"] = cNameP + "-" + cNameN;
				bMatrixNodeMap[rNameN][label + "-V"] = cNameP + "-" + cNameN;
			}
			matrix_element e;
			if (!pGND) {
				/* Positive node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = value / tsim.maxtstep;
				mElements.push_back(e);
				if (!nGND) {
					/* Positive node row and negative node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = -value / tsim.maxtstep;
					mElements.push_back(e);
					/* Negative node row and positive node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = -value / tsim.maxtstep;
					mElements.push_back(e);
				}
			}
			if (!nGND) {
				/* Negative node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = value / tsim.maxtstep;
				mElements.push_back(e);
			}
		}
		else if (i[0] == 'L') {
			/* Check if value exists, if not it's a bad inductor definition */
			try { value = modifier(devicetokens.at(3)); }
			catch (const std::out_of_range) {
				invalid_component_errors(IND_ERROR, i);
			}
			cName = "C_I" + devicetokens.at(0);
			rName = "R_" + devicetokens.at(0);
			unique_push(rowNames, rName);
			unique_push(columnNames, cName);
			bMatrixConductanceMap[rName][label] = -value;
			if (nodeP != "0" && nodeP.find("GND") == std::string::npos) {
				cNameP = "C_NV" + nodeP;
				rNameP = "R_N" + nodeP;
				unique_push(rowNames, rNameP);
				unique_push(columnNames, cNameP);
				bMatrixConductanceMap[rNameP][label] = 0.0;
				pGND = false;
			}
			else pGND = true;
			if (nodeN != "0" && nodeN.find("GND") == std::string::npos) {
				cNameN = "C_NV" + nodeN;
				rNameN = "R_N" + nodeN;
				unique_push(rowNames, rNameN);
				unique_push(columnNames, cNameN);
				bMatrixConductanceMap[rNameN][label] = 0.0;
				nGND = false;
			}
			else nGND = true;
			if (nGND) bMatrixNodeMap[rName][label + "-V"] = cNameP + "-GND";
			else if (pGND)	bMatrixNodeMap[rName][label + "-V"] = "GND-" + cNameN;
			else bMatrixNodeMap[rName][label + "-V"] = cNameP + "-" + cNameN;
			bMatrixNodeMap[rName][label + "-I"] = cName;
			matrix_element e;
			if (!pGND) {
				/* Positive node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = 0;
				mElements.push_back(e);
				if (!nGND) {
					/* Positive node row and negative node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = 0;
					mElements.push_back(e);
					/* Negative node row and positive node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = 0;
					mElements.push_back(e);
				}
				/* Positive node row and inductor current node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cName);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = 1;
				mElements.push_back(e);
				/* Inductor node row and positive node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rName);
				e.value = 1;
				mElements.push_back(e);
			}
			if (!nGND) {
				/* Negative node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = 0;
				mElements.push_back(e);
				/* Negative node row and inductor current node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cName);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = -1;
				mElements.push_back(e);
				/* Inductor node row and negative node column*/
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rName);
				e.value = -1;
				mElements.push_back(e);
			}
			/* Inductor node row and inductor current node column*/
			e.label = label;
			e.columnIndex = index_of(columnNames, cName);
			e.rowIndex = index_of(rowNames, rName);
			e.value = (-2 * value) / tsim.maxtstep;
			mElements.push_back(e);
		}
		else if (i[0] == 'V') {
			sources[label] = function_parse(i);
			cName = "C_" + devicetokens.at(0);
			rName = "R_" + devicetokens.at(0);
			unique_push(rowNames, rName);
			unique_push(columnNames, cName);
			bMatrixNodeMap[rName][label] = label;
			if (nodeP != "0" && nodeP.find("GND") == std::string::npos) {
				cNameP = "C_NV" + nodeP;
				rNameP = "R_N" + nodeP;
				unique_push(rowNames, rNameP);
				unique_push(columnNames, cNameP);
				pGND = false;
			}
			else pGND = true;
			if (nodeN != "0" && nodeN.find("GND") == std::string::npos) {
				cNameN = "C_NV" + nodeN;
				rNameN = "R_N" + nodeN;
				unique_push(rowNames, rNameN);
				unique_push(columnNames, cNameN);
				nGND = false;
			}
			else nGND = true;
			matrix_element e;
			if (!pGND) {
				/* Positive node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = 0;
				mElements.push_back(e);
				if (!nGND) {
					/* Positive node row and negative node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = 0;
					mElements.push_back(e);
					/* Negative node row and positive node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = 0;
					mElements.push_back(e);
				}
				/* Positive node row and voltage node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cName);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = 1;
				mElements.push_back(e);
				/* Voltage node row and positive node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rName);
				e.value = 1;
				mElements.push_back(e);
			}
			if (!nGND) {
				/* Negative node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = 0;
				mElements.push_back(e);
				/* Negative node row and voltage node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cName);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = -1;
				mElements.push_back(e);
				/* Voltage node row and negative node column*/
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rName);
				e.value = -1;
				mElements.push_back(e);
			}
			/* Voltage node row and voltage node column*/
			e.label = label;
			e.columnIndex = index_of(columnNames, cName);
			e.rowIndex = index_of(rowNames, rName);
			e.value = 0;
			mElements.push_back(e);
		}
		else if (i[0] == 'I') {
			sources[label] = function_parse(i);
			if (nodeP != "0" && nodeP.find("GND") == std::string::npos) {
				rNameP = "R_N" + nodeP;
				unique_push(rowNames, rNameP);
				bMatrixNodeMap[rNameP][label] = label;
				bMatrixConductanceMap[rNameP][label] = 1;
				pGND = false;
			}
			else pGND = true;
			if (nodeN != "0" && nodeN.find("GND") == std::string::npos) {
				rNameN = "R_N" + nodeN;
				unique_push(rowNames, rNameN);
				bMatrixNodeMap[rNameN][label] = label;
				bMatrixConductanceMap[rNameP][label] = 1;
				nGND = false;
			}
			else nGND = true;
		}
		else if (i[0] == 'B') {
			double jj_cap, jj_rn, jj_rzero, jj_icrit;
			jj_comp(devicetokens, "MAIN", jj_cap, jj_rn, jj_rzero, jj_icrit);
			cName = "C_P" + devicetokens.at(0);
			rName = "R_" + devicetokens.at(0);
			unique_push(rowNames, rName);
			unique_push(columnNames, cName);
			bMatrixNodeMap[rName][label + "-PHASE"] = cName;
			if (nodeP != "0" && nodeP.find("GND") == std::string::npos) {
				cNameP = "C_NV" + nodeP;
				rNameP = "R_N" + nodeP;
				unique_push(rowNames, rNameP);
				unique_push(columnNames, cNameP);
				bMatrixConductanceMap[rNameP][label + "-CAP"] = jj_cap;
				bMatrixConductanceMap[rNameP][label + "-ICRIT"] = jj_icrit;
				pGND = false;
			}
			else pGND = true;
			if (nodeN != "0" && nodeN.find("GND") == std::string::npos) {
				cNameN = "C_NV" + nodeN;
				rNameN = "R_N" + nodeN;
				unique_push(rowNames, rNameN);
				unique_push(columnNames, cNameN);
				bMatrixConductanceMap[rNameP][label + "-CAP"] = jj_cap;
				bMatrixConductanceMap[rNameP][label + "-ICRIT"] = jj_icrit;
				nGND = false;
			}
			else nGND = true;
			if (nGND) {
				bMatrixNodeMap[rName][label + "-V"] = cNameP + "-GND";
				bMatrixNodeMap[rNameP][label + "-V"] = cNameP + "-GND";
			}
			else if (pGND) {
				bMatrixNodeMap[rName][label + "-V"] = "GND-" + cNameN;
				bMatrixNodeMap[rNameN][label + "-V"] = "GND-" + cNameN;
			}
			else {
				bMatrixNodeMap[rName][label + "-V"] = cNameP + "-" + cNameN;
				bMatrixNodeMap[rNameP][label + "-V"] = cNameP + "-" + cNameN;
				bMatrixNodeMap[rNameN][label + "-V"] = cNameP + "-" + cNameN;
			}
			matrix_element e;
			if (!pGND) {
				/* Positive node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = ((2 * jj_cap) / tsim.maxtstep) + (1 / jj_rzero);
				mElements.push_back(e);
				if (!nGND) {
					/* Positive node row and negative node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = ((-2 * jj_cap) / tsim.maxtstep) - (1 / jj_rzero);
					mElements.push_back(e);
					/* Negative node row and positive node column */
					e.label = label;
					e.columnIndex = index_of(columnNames, cNameN);
					e.rowIndex = index_of(rowNames, rNameP);
					e.value = ((-2 * jj_cap) / tsim.maxtstep) - (1 / jj_rzero);
					mElements.push_back(e);
				}
				/* Positive node row and phase node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cName);
				e.rowIndex = index_of(rowNames, rNameP);
				e.value = 0;
				mElements.push_back(e);
				/* Junction node row and positive node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameP);
				e.rowIndex = index_of(rowNames, rName);
				e.value = (-tsim.maxtstep/2) * ((2 * M_PI)/PHI_ZERO);
				mElements.push_back(e);
			}
			if (!nGND) {
				/* Negative node row and column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = ((2 * jj_cap) / tsim.maxtstep) + (1 / jj_rzero);
				mElements.push_back(e);
				/* Negative node row and phase node column */
				e.label = label;
				e.columnIndex = index_of(columnNames, cName);
				e.rowIndex = index_of(rowNames, rNameN);
				e.value = 0;
				mElements.push_back(e);
				/* Junction node row and negative node column*/
				e.label = label;
				e.columnIndex = index_of(columnNames, cNameN);
				e.rowIndex = index_of(rowNames, rName);
				e.value = (tsim.maxtstep / 2) * ((2 * M_PI) / PHI_ZERO);
				mElements.push_back(e);
			}
			/* Junction node row and phase node column*/
			e.label = label;
			e.columnIndex = index_of(columnNames, cName);
			e.rowIndex = index_of(rowNames, rName);
			e.value = 1;
			mElements.push_back(e);
		}
	}
	/* Now that conductance A matrix has been identified we can convert to CSR format */
	/* Optionally display matrix contents in verbose mode */
	if (VERBOSE) {
		print_A_matrix();
	}
	/* Now convert matrix into CSR format so that it can be solved using general math libraries */
	/* First create A_matrix in matrix form so the looping is easier to accomplish */
	std::vector<std::vector<double> > A_matrix(rowNames.size(), std::vector<double>(columnNames.size()));
	for (auto i : mElements) {
		A_matrix[i.rowIndex][i.columnIndex] += i.value;
	}
	int columnCounter, elementCounter = 0;
	csr_A_matrix[1].push_back(0);
	for (auto i : A_matrix) {
		columnCounter = 0;
		for (auto j : i) {
			if (j != 0.0) {
				/* Row-major order*/
				csr_A_matrix[0].push_back(j);
				/* Element column */
				csr_A_matrix[2].push_back(columnCounter);
				elementCounter++;
			}
			columnCounter++;
		}
		csr_A_matrix[1].push_back(elementCounter);
	}
}
/*
  Print A matrix
*/
void print_A_matrix() {
	std::vector<std::vector<double> > A_matrix(rowNames.size(), std::vector<double>(columnNames.size()));
	for (auto i : mElements) {
		A_matrix[i.rowIndex][i.columnIndex] += i.value;
	}
	std::cout << "A matrix: \n";
	std::cout << std::setw(10) << std::left << "";
	for (auto i : columnNames) std::cout << std::setw(10) << std::left << i;
	std::cout << "\n";
	int counter = 0;
	for (auto i : A_matrix) {
		std::cout << std::setw(10) << std::left << rowNames.at(counter) + ":";
		for (auto j : i) {
			std::cout << std::setw(10) << std::left << j;
		}
		std::cout << "\n";
		counter++;
	}
}
function close_circuit_nel2(RP1, RP2, RX8)
%AS/MH/MP/AM - 06/27/24 this script should shut down the TDT circuit

invoke(RP1,'Halt');
invoke(RP1,'ClearCOF');

invoke(RP2,'Halt');
invoke(RP2,'ClearCOF');

invoke(RX8,'Halt');
invoke(RX8,'ClearCOF');
end


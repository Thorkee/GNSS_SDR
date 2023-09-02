% this is a code intended for automatic labeling of GNSS data
initial_id = 3088;
prn_number = [3,4,16,26,27];
%time = 289021.179296:0.02:289073.059296;
initial_idt = 0;
for id_data = 3088:80000
    if rem(id_data-initial_id,20)==0
        initial_idt = initial_idt + 1;
    parameter =       id_data - initial_id + 1;
    %Early i-Late i
    %earlyminuslate = [TckResultCT_pos(3).E_i(id_data) - TckResultCT_pos(3).L_i(id_data),TckResultCT_pos(4).E_i(id_data) - TckResultCT_pos(4).L_i(id_data),TckResultCT_pos(16).E_i(id_data) - TckResultCT_pos(16).L_i(id_data),TckResultCT_pos(26).E_i(id_data) - TckResultCT_pos(26).L_i(id_data),TckResultCT_pos(27).E_i(id_data) - TckResultCT_pos(27).L_i(id_data)];
    earlyminuslate = [];
    earlyminuslate2 = [];
    for id_sv = 1:size(prn_number,2)
        new_value = [TckResultCT_pos(prn_number(id_sv)).E_i(id_data) - TckResultCT_pos(prn_number(id_sv)).L_i(id_data)];
        earlyminuslate = [earlyminuslate; new_value];
        new_value2 = 0.5*((TckResultCT_pos(prn_number(id_sv)).E_i(id_data).^2 + TckResultCT_pos(prn_number(id_sv)).E_q(id_data).^2) - (TckResultCT_pos(prn_number(id_sv)).L_i(id_data).^2 + TckResultCT_pos(prn_number(id_sv)).L_q(id_data).^2));
        earlyminuslate2 = [earlyminuslate2;new_value2];
    end
    %Prompt i/Prompt q
    pioverpq = [TckResultCT_pos(3).P_i(id_data).^2 / TckResultCT_pos(3).P_q(id_data).^2,TckResultCT_pos(4).P_i(id_data).^2 / TckResultCT_pos(4).P_q(id_data).^2,TckResultCT_pos(16).P_i(id_data).^2 / TckResultCT_pos(16).P_q(id_data).^2,TckResultCT_pos(26).P_i(id_data).^2 / TckResultCT_pos(26).P_q(id_data).^2,TckResultCT_pos(27).P_i(id_data).^2 / TckResultCT_pos(27).P_q(id_data).^2];

    %features
    training_dataset_1(initial_idt,1) = mean(abs(earlyminuslate2));
    training_dataset_1(initial_idt,2) = std(abs(earlyminuslate2));
    training_dataset_1(initial_idt,3) = mean(abs(pioverpq));
    training_dataset_1(initial_idt,4) = std(abs(pioverpq));   
    training_dataset_1(initial_idt,5) = mean(abs(navSolutionsCT.satEA(initial_idt,:)));
    training_dataset_1(initial_idt,6) = std(abs(navSolutionsCT.satEA(initial_idt,:)));
    training_dataset_1(initial_idt,7) = mean(abs(Acquired.SNR));
    training_dataset_1(initial_idt,8) = std(abs(Acquired.SNR));

    %outputs
    training_dataset_1(initial_idt,9) = sqrt(navSolutionsCT.usrPosENU(initial_idt,1)^2+navSolutionsCT.usrPosENU(initial_idt,2)^2+navSolutionsCT.usrPosENU(initial_idt,3)^2);


    end



%     for id_sv = 1:size(prn_number,2)
%         index_data = (id_data-initial_id)*size(prn_number,2) + id_sv;
%         training_dataset_1(index_data,1) = time(initial_idt);
%         training_dataset_1(index_data,2) = prn_number(id_sv);
%         training_dataset_1(index_data,3) = TckResultCT_pos(prn_number(id_sv)).E_i(id_data);
%         training_dataset_1(index_data,4) = TckResultCT_pos(prn_number(id_sv)).E_q(id_data);
%         training_dataset_1(index_data,5) = TckResultCT_pos(prn_number(id_sv)).P_i(id_data);
%         training_dataset_1(index_data,6) = TckResultCT_pos(prn_number(id_sv)).P_q(id_data);        
%         training_dataset_1(index_data,7) = TckResultCT_pos(prn_number(id_sv)).L_i(id_data);
%         training_dataset_1(index_data,8) = TckResultCT_pos(prn_number(id_sv)).L_q(id_data); 
%         training_dataset_1(index_data,9) = TckResultCT_pos(prn_number(id_sv)).carrError(id_data); 
%         training_dataset_1(index_data,10) = TckResultCT_pos(prn_number(id_sv)).codeError(id_data); 
%         training_dataset_1(index_data,11) = navSolutionsCT.satEA(initial_idt,id_sv);
%         training_dataset_1(index_data,12) = navSolutionsCT.satAZ(initial_idt,id_sv);
%         training_dataset_1(index_data,14) = sqrt(navSolutionsCT.usrPosENU(initial_idt,1)^2+navSolutionsCT.usrPosENU(initial_idt,2)^2+navSolutionsCT.usrPosENU(initial_idt,3)^2);
%         data(index_data,9) = sqrt(navSolutionsCT.usrPosLLH(initial_idt,1)^2+navSolutionsCT.usrPosLLH(initial_idt,2)^2+navSolutionsCT.usrPosLLH(initial_idt,3)^2);
%     end
end



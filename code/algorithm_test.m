clear

%% INPUT

algorithm = @firefly;
data_names = {'scpe1', 'scpe2', 'scpe3'};
runs_per_dataset = 5;

%% SCRIPT

no_datasets = length(data_names);

times = zeros(no_datasets, 1);
fitnesses = zeros(no_datasets, 1);
% generations = zeros(no_datasets, 1);
% solutions = zeros(no_datasets, 1);

for data_index = 1:no_datasets

    dataset = data_names{data_index};

    [A, c] = import_scp_data(dataset);

    times_for_avg = zeros(runs_per_dataset, 1);
    fit_for_avg = zeros(runs_per_dataset, 1);

    for run = 1:runs_per_dataset

    tic
    [sol, fit, gen] = algorithm(A,c);

    times_for_avg(run) = toc;
    fit_for_avg(run) = fit;

    end

    times(data_index) = mean(times_for_avg);
    fitnesses(data_index) = mean(fit_for_avg);

    
    % mkdir('../OUTPUT')
    % save(strcat('../OUTPUT/',dataset,'-OUTPUT.mat'), 'time_taken', 'fit', 'sol', 'gen')

end

table(string(data_names)', times, fitnesses)
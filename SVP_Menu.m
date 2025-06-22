clc; clear;

function SVP_Menu_f()
    fig = uifigure('Name', 'SVP Menu', ...
                   'Position', [8, 270, 330, 260],... % [x, y, ширина, висота]
                   'Color', [0.8902, 0.8902, 0.8902] ); 

    lbl = uilabel(fig, ...
        'Text', 'Menu', ...
        'Position', [110, 205, 100, 35], ...
        'FontSize', 28, 'FontColor', [0.0510, 0.0941, 0.3647], ... 
        'HorizontalAlignment', 'center');
    
    % tlačidlo "Ukonči program"
    btn_exit = uibutton(fig, ...
        'Text', 'Ukonči program', ...
        'Position', [110, 160, 100, 30], ...
        'BackgroundColor', [0.7333, 0.7255, 0.7255], 'FontColor', [1, 0.0, 0.0], ... 
        'ButtonPushedFcn', @(btn, event) exit_Menu(fig)); % Закриває вікно % close
    
    % tlačidlo "Štatistika"
    btn_statistika = uibutton(fig, ...
        'Text', 'Štatistika', ...
        'Position', [110, 120, 100, 30], ...
        'BackgroundColor', [0, 0.6235, 0.8706], 'FontColor', [1.0000, 1.0000, 1.0000], ... 
        'ButtonPushedFcn', @(btn, event) SVP_Statistika());
    
    % tlačidlo "Matice"
    btn_matrice = uibutton(fig, ...
        'Text', 'Matice', ...
        'Position', [110, 80, 100, 30], ...
        'BackgroundColor', [0, 0.6235, 0.8706], 'FontColor', [1.0000, 1.0000, 1.0000], ... 
        'ButtonPushedFcn', @(btn, event) SVP_Matice());
    
    % tlačidlo "Grafy"
    btn_grafy = uibutton(fig, ...
        'Text', 'Grafy', ...
        'Position', [110, 40, 100, 30], ...
        'BackgroundColor', [0, 0.6235, 0.8706], ... 
        'FontColor', [1.0000, 1.0000, 1.0000], ... 
        'ButtonPushedFcn', @(btn, event) SVP_Grafy());
end

function exit_Menu(fig)
    close(fig);
    clc;  
    clearvars;
end

function clear_Harok(inputFile, harokName)
    try
        if ~isfile(inputFile)
            error(['Súbor "', inputFile, '" nebol nájdený.']);
        end

        [~, harokNames] = xlsfinfo(inputFile);
        
        % Відкриваємо Excel через ActiveX
        Excel = actxserver('Excel.Application');
        Excel.Visible = false; % Excel працює у фоновому режимі
        Workbook = Excel.Workbooks.Open(fullfile(pwd, inputFile));
        
        % Перевіряємо, чи існує потрібний аркуш
        sheetExists = ismember(harokName, harokNames);
        
        if sheetExists
            Sheet = Workbook.Sheets.Item(harokName); % Якщо аркуш існує, очищаємо його
            Sheet.Cells.Clear();
        else
            Workbook.Sheets.Add.Name = harokName; % Якщо аркуш не існує, додаємо новий
        end

        Workbook.Save();
        Workbook.Close();
        invoke(Excel, 'Quit');
        delete(Excel);        
    catch ME
        errordlg(['Hárok sa nepodarilo vyčistiť "', harokName, '": ', ME.message], 'Error');
    end
end

function SVP_Statistika()
    inputFolder = 'DataInput'; % priečinok
    inputFile = fullfile(inputFolder, 'SVP-Statistika.xlsx');
    
    if ~exist(inputFolder, 'dir')
        errordlg(['Priečinok "', inputFolder, '" neexistuje!'], 'Error');
        return;
    end
    
    if ~exist(inputFile, 'file')
        errordlg(['Súbor "', inputFile, '" nebol nájdený! Skontrolujte názov a umiestnenie.'], 'Error');
        return;
    end
  
    sheetToClear = 'ZakladneInfo';
    clear_Harok(inputFile, sheetToClear);

    % zapis k ZakladneInfo
    try
        team_Info = {
            '------------------------';
            'Názov tímu';
            'Project Manager';
            'Developer';
            'Tester';
            'Data Analyser';
            '------------------------';
        };

        team_Info_tbc = {
            '--------------------------';
            'Florence Team';
            'Strelchenko Oleksandr';
            'Tanchuk Oleksandr';
            'Sheremet Yaroslav';
            'Hapochka Valentyn';
            '--------------------------';
        };

        writecell(team_Info, inputFile, 'Sheet', 'ZakladneInfo', 'Range', 'A1');
        writecell(team_Info_tbc, inputFile, 'Sheet', 'ZakladneInfo', 'Range', 'B1');
        
        excelApp = actxserver('Excel.Application'); 
        excelApp.Visible = false; 
        workbook = excelApp.Workbooks.Open(fullfile(pwd, inputFile));
        
        sheet = workbook.Sheets.Item('ZakladneInfo');

        range1 = sheet.Range('A1:B2');
        range2 = sheet.Range('A7:B7');
        range3 = sheet.Range('B2:B2');
        range4 = sheet.Range('A3:A6');

        range1.Font.Bold = true;
        range2.Font.Bold = true;
        range4.Font.Bold = true;
        range4.Font.Italic = true;
       
        MidnightBlue = 25 + 25*256 + 112*256^2;
        range4.Font.Color = MidnightBlue;

        lightBlue = 173 + 216 * 256 + 230 * 256^2;
        range3.Interior.Color = lightBlue;

        workbook.Save(); % Зберегти та закрити   
        workbook.Close();
        excelApp.Quit();
        delete(excelApp); % Видалити об'єкт Excel

        programInfo = {
            ['Dátum generácie: ', datestr(now)];
            'Popis: Projekt zameraný na analýzu a spracovanie dát,'; 
            '       vrátane matematických operácií, štatistiky, generovania'; 
            '       matíc, tvorby grafov a automatizácie výpočtov'; 
            '       s využitím MATLABu, v súlade s požiadavkami zadania.'; 
            ' ';
            'Autor: Florence Team';
        };
        writecell(programInfo, inputFile, 'Sheet', 'ZakladneInfo', 'Range', 'D1');
        
        excelApp = actxserver('Excel.Application');
        excelApp.Visible = false;
        workbook = excelApp.Workbooks.Open(fullfile(pwd, inputFile));
        
        sheet = workbook.Sheets.Item('ZakladneInfo');
        
        range1 = sheet.Range('D7:D8');
        range2 = sheet.Range('D2:D5');

        range1.Font.Bold = true;
        range2.Font.Italic = true;

        workbook.Save();
        workbook.Close();
        excelApp.Quit();
        delete(excelApp);

        data = readtable(inputFile, 'Sheet', 'VstupneData', 'VariableNamingRule', 'preserve');
        
        if iscell(data.Pocet_obyvatelov_sidla) || isstring(data.Pocet_obyvatelov_sidla)
            data.Pocet_obyvatelov_sidla = str2double(data.Pocet_obyvatelov_sidla); 
        end
                 
        % Відфільтровуємо міста з населенням >= 50000
        cities_count = data(data.Pocet_obyvatelov_sidla >= 50000, :);
        cities_count = sortrows(cities_count, 'Pocet_obyvatelov_sidla', 'descend'); % Сортуємо по чисельності населення

        % Відфільтровуємо села з населенням < 1000
        villages_count = data(data.Pocet_obyvatelov_sidla < 1000, :);
        villages_count = sortrows(villages_count, 'Pocet_obyvatelov_sidla', 'descend'); % Сортуємо по чисельності населення

        columnsToKeep = [1:8, width(data)];
        cities_count = cities_count(:, columnsToKeep);
        villages_count = villages_count(:, columnsToKeep);
        
        sheetToClear = 'VystupneData'; 
        clear_Harok(inputFile, sheetToClear);
        writetable(cities_count, inputFile, 'Sheet', 'VystupneData', 'Range', 'A1');
        writetable(villages_count, inputFile, 'Sheet', 'VystupneData', 'Range', ['A', num2str(height(cities_count) + 3)]);

        prompt = {'Zadajte mesiac (1-12):', 'Zadajte nadmorskú výšku (m):', 'Zadajte vzdialenosť (km):'}; 
        dlg_title = 'Nastavenie filtra'; 
        num_lines = 1; 
        defaultans = {'1', '200', '100'}; 
        answer = inputdlg(prompt, dlg_title, num_lines, defaultans);
        
        if isempty(answer)
            return;
        end
        
        selected_month = str2double(answer{1});
        selected_height = str2double(answer{2});
        selected_distance = str2double(answer{3});
    
        if isnan(selected_month) || isnan(selected_height) || isnan(selected_distance) || selected_month < 1 || selected_month > 12 || selected_distance < 0
            errordlg('Neplatné hodnoty vstupu. Skontrolujte a skúste znova.', 'Error');
            return;
        end
            
        cities = data(data.Nadmorska_vyska_m < selected_height, :);
        villages = data(data.Nadmorska_vyska_m >= selected_height, :);

        avgTempCities = mean(cities{:, sprintf('Teplota_%02d', selected_month)}, 'omitnan');
        avgRainCities = mean(cities{:, sprintf('Zrazky_%02d', selected_month)}, 'omitnan');
    
        avgTempVillages = mean(villages{:, sprintf('Teplota_%02d', selected_month)}, 'omitnan');
        avgRainVillages = mean(villages{:, sprintf('Zrazky_%02d', selected_month)}, 'omitnan');
        
        if isnan(avgTempCities), avgTempCities = 'N/A'; end
        if isnan(avgRainCities), avgRainCities = 'N/A'; end
        if isnan(avgTempVillages), avgTempVillages = 'N/A'; end
        if isnan(avgRainVillages), avgRainVillages = 'N/A'; end

        results_start_row = 1; 
     
        selectedColumns = [1, 2, 3, 5, 7, 8, width(data)];  
        monthColumn = {sprintf('Teplota_%02d', selected_month), sprintf('Zrazky_%02d', selected_month)};
        columnsToKeep = [selectedColumns, find(ismember(data.Properties.VariableNames, monthColumn))];
        
        cities_selected_columns = cities(:, columnsToKeep);
        villages_selected_columns = villages(:, columnsToKeep);

        cities_start_row = height(cities_count) + height(villages_count) + 2; 
        writecell({'Mestá s nadmorskou výškou menšou ako vybraná hodnota'}, inputFile, 'Sheet', 'VystupneData', 'Range', ['A', num2str(cities_start_row+3)]);
        writetable(cities_selected_columns, inputFile, 'Sheet', 'VystupneData', 'Range', ['A', num2str(cities_start_row +4)]);
        
        villages_start_row = cities_start_row + height(cities_selected_columns) + 1; 
        writecell({'Obce s nadmorskou výškou väčšou alebo rovnou vybranej hodnote'}, inputFile, 'Sheet', 'VystupneData', 'Range', ['A', num2str(villages_start_row+5)]);
        writetable(villages_selected_columns, inputFile, 'Sheet', 'VystupneData', 'Range', ['A', num2str(villages_start_row+6)]);

        cities_within_distance = cities(cities.Vzdialenost_km <= selected_distance, :);
        villages_within_distance = villages(villages.Vzdialenost_km <= selected_distance, :);

        result_table = [cities_within_distance; villages_within_distance];
        columnsToKeep = [1:5, width(result_table)];
        filtered_table = result_table(:, columnsToKeep);

        filtered_start_row = villages_start_row + height(villages_selected_columns) + 2;
        writetable(filtered_table, inputFile, 'Sheet', 'VystupneData', 'Range', ['A', num2str(filtered_start_row+6)]);

        excelApp = actxserver('Excel.Application'); 
        excelApp.Visible = false; 
        workbook = excelApp.Workbooks.Open(fullfile(pwd, inputFile));

        sheet = workbook.Sheets.Item('VystupneData');

        % Design tbl
        cities_count_header_range = sheet.Range(['A1:', 'I1']); 
        cities_count_header_range.Font.Bold = true;
        cities_count_header_range.HorizontalAlignment = -4108; % xlCenter
        villages_count_header_start_row = height(cities_count) + 3; % Рядок, де починаються села
        villages_count_header_range = sheet.Range(['A', num2str(villages_count_header_start_row), ':', 'I', num2str(villages_count_header_start_row)]);
        villages_count_header_range.Font.Bold = true;
        villages_count_header_range.HorizontalAlignment = -4108;

        cities_selected_header_start_row = cities_start_row + 3; % Рядок, де починається таблиця
        cities_selected_header_range = sheet.Range(['A', num2str(cities_selected_header_start_row), ':', 'I', num2str(cities_selected_header_start_row + 1)]);
        cities_selected_header_range.Font.Bold = true;
        villages_selected_header_start_row = villages_start_row + 5; % Рядок, де починається таблиця
        villages_selected_header_range = sheet.Range(['A', num2str(villages_selected_header_start_row), ':', 'I', num2str(villages_selected_header_start_row + 1)]);
        villages_selected_header_range.Font.Bold = true;

        filtered_header_start_row = filtered_start_row + 6; % Рядок, де починається таблиця
        filtered_header_range = sheet.Range(['A', num2str(filtered_header_start_row), ':', 'I', num2str(filtered_header_start_row)]);
        filtered_header_range.Font.Bold = true;
        filtered_header_range.HorizontalAlignment = -4108;

        workbook.Save(); % Зберегти та закрити
        workbook.Close();
        excelApp.Quit();
        delete(excelApp);
        
        % --- Charakteristika --- %
        max_height = max(data.Nadmorska_vyska_m);
        min_height = min(data.Nadmorska_vyska_m);
        R = max_height - min_height;

        n = height(data);
        m = round(sqrt(n));
        if mod(m, 2) == 1
            m = m + 1;
        end

        h = ceil(R / m);

        a = min_height; 
        b = a + h;
        ai = a;
        bi = b;
        xi = (a + b) / 2;
        
        i_values = [];
        ai_values = [];
        bi_values = [];
        xi_values = [];
        ni_values = [];
        Ni_values = [];
        fi_values = [];
        Fi_values = [];
        
        cumulative_N = 0; 
        
        for i = 1:m
            ni = sum(data.Nadmorska_vyska_m >= ai & data.Nadmorska_vyska_m < bi);
            ni_values = [ni_values; ni];
            
            fi = ni / n;
            fi_values = [fi_values; fi];
  
            cumulative_N = cumulative_N + ni;
            Ni_values = [Ni_values; cumulative_N];
            
            Fi = cumulative_N / n;
            Fi_values = [Fi_values; Fi];
            
            i_values = [i_values; i];
            ai_values = [ai_values; ai];
            bi_values = [bi_values; bi];
            xi_values = [xi_values; xi];
            
            ai = bi;
            bi = ai + h;
            xi = (ai + bi) / 2;            
        end
        
        arithmetic_mean = sum(xi_values .* ni_values) / n; % aritmetický priemer
    
        [~, max_idx] = max(ni_values);
        
        if max_idx == 1
            d1 = ni_values(max_idx);
            d2 = ni_values(max_idx) - ni_values(max_idx + 1);
        elseif max_idx == length(ni_values)
            d1 = ni_values(max_idx) - ni_values(max_idx - 1);
            d2 = 0;
        else
            d1 = ni_values(max_idx) - ni_values(max_idx - 1);
            d2 = ni_values(max_idx) - ni_values(max_idx + 1);
        end
        
        a0 = ai_values(max_idx);
        mode_value = a0 + h * (d1 / (d1 + d2)); % modus

        median_idx = find(Ni_values >= n / 2, 1);
        if median_idx > 1 && median_idx <= length(Ni_values)
            ae = ai_values(median_idx);
            Ni_prev = Ni_values(median_idx - 1);
            n_i = ni_values(median_idx);
            median_value = ae + h * ((n / 2 - Ni_prev) / n_i); % medián
        else
            median_value = NaN; 
        end

        variance = sum(ni_values .* (xi_values - arithmetic_mean).^2) / (n - 1);

        std_deviation = sqrt(variance);
        
        sheetToClear = 'Charakteristiky';
        clear_Harok(inputFile, sheetToClear);
       
        stats_table = table(  arithmetic_mean, mode_value, median_value, variance, std_deviation);
        
        data_to_write = {
            'n =', n;
            'm =', m;
            'Max Height =', max_height;
            'Min Height =', min_height;
            'R =', R;
            'h =', h;
        };

        writecell(data_to_write, inputFile, 'Sheet', 'Charakteristiky', 'Range', 'A1');

        freq_table = table(i_values, ai_values, bi_values, xi_values, ni_values, Ni_values, fi_values, Fi_values);
        freq_table.Properties.VariableNames = {'i', 'ai', 'bi', 'xi', 'ni', 'Ni', 'fi', 'Fi'};
        
        if ~isempty(freq_table)
            writetable(freq_table, inputFile, 'Sheet', 'Charakteristiky', 'Range', 'A8');
            freq_table_rows = height(freq_table);
        else
            freq_table_rows = 0; 
        end

        start_row_for_stats = 8 + freq_table_rows + 2;

        stats_table.Properties.VariableNames = {'Aritmetický priemer', 'Modus', 'Median', 'Rozptyl', 'Smerodajná odchýlka'};
        
        if ~isempty(stats_table)
            writetable(stats_table, inputFile, 'Sheet', 'Charakteristiky', 'Range', sprintf('A%d', start_row_for_stats));
        end
        
        % Design tbl
        excelApp = actxserver('Excel.Application'); 
        excelApp.Visible = false;
        workbook = excelApp.Workbooks.Open(fullfile(pwd, inputFile));
        
        sheets_info = {
            'Charakteristiky', sprintf('A1:H%d', start_row_for_stats + height(stats_table) + 1); 
        };
        
        for i = 1:size(sheets_info, 1)
            sheet_name = sheets_info{i, 1};
            range_string = sheets_info{i, 2};
            
            sheet = workbook.Sheets.Item(sheet_name); % Вибір аркуша
            range = sheet.Range(range_string);        % Визначення діапазону
            range.HorizontalAlignment = -4108;        % Вирівнювання по центру (-4108 = xlCenter)
        end
        
        sheet = workbook.Sheets.Item('Charakteristiky');
        data_to_write_header_range = sheet.Range('A1:A6');
        data_to_write_header_range.Font.Bold = true; % Жирний шрифт
        
        freq_table_header_start = 8;
        freq_table_header_range = sheet.Range(sprintf('A%d:H%d', freq_table_header_start, freq_table_header_start));
        freq_table_header_range.Font.Bold = true;
        
        stats_table_header_start = start_row_for_stats;
        stats_table_header_range = sheet.Range(sprintf('A%d:E%d', stats_table_header_start, stats_table_header_start));
        stats_table_header_range.Font.Bold = true;
        
        workbook.Save();
        workbook.Close();
        excelApp.Quit();
        delete(excelApp);

        msgbox(['Informácie boli úspešne zapísané do súboru "', inputFile, '".'], 'Úspech');
        winopen(inputFile);
    catch ME
        errordlg(['Chyba pri zapisovaní do Excel: ', ME.message], 'Error');
    end
end

function SVP_Matice()
    % --- Časť 1: Generacia matice A a stvorenie matice B --- %

    % matica A (m×n)
    m = randi([2, 10]); % m
    n = randi([2, 10]); % n
    
    % interval [a, b], a < b
    a = -100 + 200 * rand(); % a z[-100, 100]
    b = a + (100 - a) * rand(); % b, a < b
    a = floor(a); % Округлення вниз
    b = ceil(b);  % Округлення вгору
    
    A = randi([a, b], m, n);
    B = A * A';
    
    inputFolder = 'DataInput';
    if ~exist(inputFolder, 'dir')
        mkdir(inputFolder);
    end

    outputFolder = 'DataOutput';
    if ~exist(outputFolder, 'dir') % zapís do súboru "Matice.txt"
        mkdir(outputFolder);
    end
    maticeFile = fullfile(inputFolder, 'Matice.txt');
    fileID = fopen(maticeFile, 'w');
    fprintf(fileID, '--- Generacia matice A: ---\n');
    fprintf(fileID, 'Rozmer: %d×%d\n', m, n);
    fprintf(fileID, 'Interval prvkov [%d, %d]\n', a, b);

    fprintf(fileID, 'Matica A:\n'); % matica A
    for i = 1:size(A, 1)
        fprintf(fileID, '%d ', A(i, :));
        fprintf(fileID, '\n');
    end
    
    fprintf(fileID, '\n--- Vytvorená matica B: ---');
    fprintf(fileID, '\nMatica B = A * A'':\n'); % matica B
    for i = 1:size(B, 1)
        fprintf(fileID, '%d ', B(i, :));
        fprintf(fileID, '\n');
    end

    fclose(fileID);

    % --- Časť 2: Spracovanie matice B ---
    
    B_imported = B;
    rank_B = rank(B_imported);
    det_B = det(B_imported); % determinant
    inv_B = inv(B_imported); % inverzna matica

    resultsFile = fullfile(outputFolder, 'MaticeVysledky.txt'); % zapís do súboru "MaticeVysledky.txt"
    fileID = fopen(resultsFile, 'w');
    fprintf(fileID, '--- Výsledky spracovania matice B: ---\n\n');
    fprintf(fileID, 'Hodnosť matice B: %d\n', rank_B);
    fprintf(fileID, 'Determinant matice B: %e\n', det_B);

    if isnumeric(inv_B)
        fprintf(fileID, 'Inverzná matica B:\n');
        for i = 1:size(inv_B, 1)
            fprintf(fileID, '%f ', inv_B(i, :));
            fprintf(fileID, '\n');
        end
    else
        fprintf(fileID, '%s\n', inv_B);
    end

    fclose(fileID);
    
    successMsg = sprintf(['Matice A a B boli úspešne generované a zapísané do súboru: %s\n\n', ... 
            'Výsledky spracovania matice B boli zapísané do súboru: %s'], maticeFile, resultsFile);
    msgbox(successMsg, 'Úspech');
    winopen(maticeFile);
    winopen(resultsFile);
end

function SVP_Grafy()
    outputFolder = 'DataOutput';
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    outputFile = fullfile(outputFolder, 'VystupPostupnisti.txt');
    
    prompt = {'Zadajte a:', 'Zadajte b:', 'Zadajte c:', ...
              'Zadajte a0 (Začiatočný člen postupnosti):', 'Zadajte q (násobiteľ):', ...
              'Zadajte m1 (začiatočný index):', 'Zadajte m2 (koncový index):'}; 
    dlgtitle = 'Zadávanie parametrov';
    dims = [1 45];
    defaultInput = {'1', '1', '1', '1', '1.25', '1', '10'};
    params = inputdlg(prompt, dlgtitle, dims, defaultInput);

    if isempty(params)
        disp('Vstup zrušený');
        return;
    end
    
    a = str2double(params{1});
    b = str2double(params{2});
    c = str2double(params{3});
    a0 = str2double(params{4});
    q = str2double(params{5});
    m1 = str2double(params{6});
    m2 = str2double(params{7});
    
    if mod(m1, 1) ~= 0 || mod(m2, 1) ~= 0 || m1 < 0 || m2 < 0 || m1 >= m2 || q <= 0 || ...
            isnan(a) || isnan(b) || isnan(c) || isnan(a0) || isnan(q) || isnan(m1) || isnan(m2)
        errordlg('Nesprávne zadanie parametrov. Skúste znova.', 'Error');
        return;
    end
    
    terms = [10, 50, 100, 1000, 10000, 100000, 1000000];
    sums = zeros(size(terms));
    
    for i = 1:length(terms)
        n = terms(i);
        sums(i) = a0 * (1 - q^n) / (1 - q); % Сума перших n членів
    end
    
    % Сума членів від am1 до am2
    sum_m1_m2 = a0 * (q^(m1 - 1)) * (1 - q^(m2 - m1 + 1)) / (1 - q);

    % Нескінченна сума прогресії (якщо q < 1)
    if q < 1
        S_inf = a0 / (1 - q);
    else
        S_inf = Inf; 
    end
    
    fileID = fopen(outputFile, 'w');
    fprintf(fileID, '--- Výpočty geometrickej progresívnosti ---\n\n');
    for i = 1:length(terms)
        fprintf(fileID, 'Súčet prvých %d členov: %.6f\n', terms(i), sums(i));
    end
    fprintf(fileID, 'Súčet členov od a%d do a%d: %.6f\n', m1, m2, sum_m1_m2);
    fprintf(fileID, 'Nekonečná suma S: %.6f\n', S_inf);
    fclose(fileID);

    successMsg = sprintf('Výstupy sa zapísali do súboru:\n%s\n', outputFile);
    msgbox(successMsg, 'Úspech');

    winopen(outputFile);

    % Побудова графіка
    x = -10:0.1:10; % x для графіка
    y = a * x.^2 + b * x + c; % Квадратична функція
    
    geom_series = a0 * q.^(1:10); % Значення перших 10 членів прогресії
    
    % Створення графічного вікна
    figure('Name', 'Graf funkcie f & Prvý 10 členov geometrickej postupnosti', 'NumberTitle', 'off', 'Color', [0.9 0.9 0.9]);
    
    % Графік квадратичної функції
    subplot(2, 1, 1);
    plot(x, y, 'b', 'LineWidth', 2);
    title('Kvadraticka funkcia f(x) = ax^2 + bx + c');
    xlabel('x');
    ylabel('f(x)');
    grid on;
    
    % Графік геометричної прогресії
    subplot(2, 1, 2);
    stem(1:10, geom_series, 'r', 'LineWidth', 1.5);
    title('Prvý 10 členov geometrickej postupnosti');
    xlabel('Členy');
    ylabel('a_n');
    grid on;
end

SVP_Menu_f
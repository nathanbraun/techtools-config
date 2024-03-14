local helpers = {}

local zk = require("zk")

local function stringToDate(dateString)
    local year, month, day = dateString:match("(%d+)%-(%d+)%-(%d+)")
    year, month, day = tonumber(year), tonumber(month), tonumber(day)

    -- Create a Lua date table
    local dateTable = os.date("*t", os.time{year=year, month=month, day=day, hour=0, min=0, sec=0})
    return dateTable
end

local function getMondayDateFromYearWeek(yearWeek)
    -- Split the year and week strings
    local year, week = yearWeek:match("^(%d%d%d%d)-(%d%d)$")

    -- Convert year and week to numbers
    year = tonumber(year)
    week = tonumber(week)

    -- Find the first day of the year
    local firstDayOfYear = os.time({ year = year, month = 1, day = 1 })

    -- Find the weekday of the first day of the year
    local firstDayWeekday = os.date("*t", firstDayOfYear).wday

    -- Calculate the days to the first Monday of the year
    -- (Note: Lua os.date() considers Sunday as 1, hence we subtract 2 and then modulo by 7)
    local daysToFirstMonday = (9 - firstDayWeekday) % 7

    -- Calculate the timestamp for the first Monday of the specified week
    -- Subtract one from week number because Lua counts weeks from zero
    local mondayTimestamp = firstDayOfYear + (daysToFirstMonday + (week - 1) * 7) * 24 * 3600

    -- Get the os.date table for the calculated Monday timestamp
    local mondayDate = os.date("*t", mondayTimestamp)

    return mondayDate
end

local function getWeekOffset(weekString, offset)
    local year, week = weekString:match("(%d+)%-(%d+)")
    year, week = tonumber(year), tonumber(week)

    -- Adjust the week number based on the offset
    week = week + offset

    -- Get the total number of weeks in the year
    local jan1 = os.time{year=year, month=1, day=1, hour=0, min=0, sec=0}
    local dec31 = os.time{year=year, month=12, day=31, hour=0, min=0, sec=0}
    local dec31_weekday = os.date("*t", dec31).wday
    local days_in_year = os.difftime(dec31, jan1) / (86400) + 1
    local weeks_in_year = math.ceil((days_in_year - (8 - os.date("*t", jan1).wday)) / 7)

    -- Handle year transition
    if week > weeks_in_year then
        year = year + 1
        week = 1
    elseif week <= 0 then
        year = year - 1
        
        -- Get the total number of weeks in the previous year
        jan1 = os.time{year=year, month=1, day=1, hour=0, min=0, sec=0}
        dec31 = os.time{year=year, month=12, day=31, hour=0, min=0, sec=0}
        days_in_year = os.difftime(dec31, jan1) / (86400) + 1
        weeks_in_year = math.ceil((days_in_year - (8 - os.date("*t", jan1).wday)) / 7)

        week = weeks_in_year
    end

    return string.format("%s-%02d", year, week)
end

local function getDayOffset(dateString, offset)
    local year, month, day = dateString:match("(%d+)%-(%d+)%-(%d+)")
    year, month, day = tonumber(year), tonumber(month), tonumber(day)

    -- Adjust the day based on the offset
    local targetTime = os.time{year=year, month=month, day=day, hour=0, min=0, sec=0} + (offset * 86400)
    local targetDateTable = os.date("*t", targetTime)

    -- Format the date back to the YYYY-MM-DD format
    return string.format("%04d-%02d-%02d", targetDateTable.year, targetDateTable.month, targetDateTable.day)
end

local function getOpenBufferPaths()
  local paths = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
          local path = vim.api.nvim_buf_get_name(buf)
          if path and #path > 0 then
              table.insert(paths, path)
          end
      end
  end
  return paths
end

local function getYearWeek(today)
    local jan1 = os.time{year=today.year, month=1, day=1, hour=0, min=0, sec=0} -- Ensure we have a complete date table
    local jan1_weekday = os.date("*t", jan1).wday
    local days_to_first_monday = (9 - jan1_weekday) % 7 -- Days until the first Monday of the year
    local first_monday = jan1 + (days_to_first_monday * 86400) -- Adding days in seconds to Jan 1st
    local today_time = os.time{year=today.year, month=today.month, day=today.day, hour=0, min=0, sec=0} -- Ensure complete date table for today
    local today_weekday = os.date("*t", today_time).wday
    local year = today.year
    local week_num -- Declare week_num at function scope

    if today_time >= first_monday then
        -- Calculate the week number since the first Monday of the year
        week_num = math.floor(((today_time - first_monday) / 86400) / 7) + 1
        if today_weekday == 2 then -- If today is Monday, ensure it's counted as the start of the new week
            week_num = week_num + 1
        end
    else
        -- If the date is before the first Monday, the week number is 0
        week_num = 0
    end
    
    return string.format("%s-%02d", year, week_num) -- Year and week number
end


function helpers.yankName(options, picker_options)
  zk.pick_notes(options, picker_options, function(notes)
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()

    if picker_options.multi_select == false then
      notes = { notes }
    end
    for _, note in ipairs(notes) do
      local nline = line:sub(0, pos) .. "[" .. note.title  .. "]" .. "(" .. note.path:sub(1,-6) .. ")" .. line:sub(pos + 1)
      vim.api.nvim_set_current_line(nline)
    end
  end)
end

function helpers.zkNotesWithOpenPaths()
    local open_paths = getOpenBufferPaths()
    -- Convert the Lua table of paths into a Vimscript list-like string
    local vim_list = '{' .. table.concat(vim.tbl_map(function(path)
        -- Escape single quotes and wrap each path in double quotes
        return string.format('"%s"', vim.fn.escape(path, '"'))
    end, open_paths), ', ') .. '}'
    -- Execute the ZkNotes command with the properly formatted paths
    vim.cmd('ZkNotes { hrefs = ' .. vim_list .. ' }')
end

function helpers.zkWeekNote()
    -- Get the current date
    local today = os.date("*t")

    -- Prepare the extra table with formatted date strings for 'day1' (Monday) and 'day7' (Sunday)
    local title = getYearWeek(today)

    -- Calculate the week number with respect to the first Monday of the year
    local year = today.year

    -- If today is Monday, days_since_monday should be 0; if today is Sunday, days_since_monday should be 6
    local days_since_monday = (today.wday - 2) % 7
    local days_until_sunday = (8 - today.wday) % 7

    -- Now calculate the first and last day of the week (Monday and Sunday)
    local first_day_of_week = os.time{year=today.year, month=today.month, day=today.day - days_since_monday, hour=0, min=0, sec=0}
    local last_day_of_week = os.time{year=today.year, month=today.month, day=today.day + days_until_sunday, hour=0, min=0, sec=0}


    local extra = {
        first = os.date("%Y-%m-%d", first_day_of_week),  -- Monday
        last = os.date("%Y-%m-%d", last_day_of_week)    -- Sunday
    }

    -- Convert the extra table into a string in dictionary format
    local extra_str = string.format("{ group = 'weekly', title = '%s', extra = { day1 = '%s', day7 = '%s' } }",
                                     title, extra.first, extra.last)

    -- Execute the ZkNew command with the extra string
    vim.cmd('ZkNew ' .. extra_str)
end

function helpers.zkDayNote()

    local weekdays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

    -- Get the current date
    local today = os.date("*t")

    local year = today.year
    local month = string.format("%02d", today.month)
    local day = string.format("%02d", today.day)
    local title = string.format("%d-%s-%s", year, month, day)

    local day_of_week = weekdays[today.wday]

    -- Convert the extra table into a string in dictionary format
    local extra_str = string.format("{ group = 'daily', title = '%s', extra = { dow = '%s'} }",
                                     title, day_of_week)

    -- Execute the ZkNew command with the extra string
    vim.cmd('ZkNew ' .. extra_str)
end

function helpers.zkWeekNoteOffset(offset)
    -- Get the filename of the current buffer
    local current_file = vim.fn.expand('%:t')

    -- Check if the file matches the format YYYY-WW.wiki
    if not string.match(current_file, "^%d%d%d%d%-%d%d%.wiki$") then
      helpers.zkWeekNote()
      return
    end

    local title = string.sub(current_file, 1, -6)  -- Remove the .wiki extension
    local next_week = getWeekOffset(title, offset)

    local first_dow = getMondayDateFromYearWeek(next_week)

    local year = first_dow.year

    local first_day_of_week = os.time{year=first_dow.year, month=first_dow.month, day=first_dow.day, hour=0, min=0, sec=0}
    local last_day_of_week = os.time{year=first_dow.year, month=first_dow.month, day=first_dow.day + 6, hour=0, min=0, sec=0}

    local extra = {
        first = os.date("%Y-%m-%d", first_day_of_week),  -- Monday
        last = os.date("%Y-%m-%d", last_day_of_week)    -- Sunday
    }

    local extra_str = string.format("{ group = 'weekly', title = '%s', extra = { day1 = '%s', day7 = '%s' } }",
                                     next_week, extra.first, extra.last)

    vim.cmd('ZkNew ' .. extra_str)
end

function helpers.zkDayNoteOffset(offset)
    local weekdays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

    -- Get the filename of the current buffer
    local current_file = vim.fn.expand('%:t')

    -- Check if the file matches the format YYYY-WW.wiki
    if not string.match(current_file, "^%d%d%d%d%-%d%d%-%d%d%.wiki$") then
      helpers.zkDayNote()
      return
    end

    local title = string.sub(current_file, 1, -6)  -- Remove the .wiki extension
    local day_string = getDayOffset(title, offset)
    local day_date = stringToDate(day_string)

    local day_of_week = weekdays[day_date.wday]

    -- Convert the extra table into a string in dictionary format
    local extra_str = string.format("{ group = 'daily', title = '%s', extra = { dow = '%s'} }",
                                     day_string, day_of_week)

    -- Execute the ZkNew command with the extra string
    vim.cmd('ZkNew ' .. extra_str)
end

function helpers.CreateMarkdownLinkFromWiki()
    local path = vim.api.nvim_buf_get_name(0)
    local title = ""
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match("^title: ") then
            title = line:match("^title: (.*)$")
            break
        end
    end
    
    -- Use the NOTES_DIR environment variable as the path prefix
    local path_prefix = vim.env.NOTES_DIR
    if not string.match(path_prefix, "/$") then
        path_prefix = path_prefix .. '/'
    end
    
    -- Remove the path prefix and the ".wiki" extension to get the relative path
    path = path:gsub("^" .. path_prefix, "")
    path = path:gsub("%.wiki$", "")
    
    -- Use the file name without the extension as the link text if the title is not found
    if title == "" then
        local filename = path:match("([^/]+)$")
        title = filename or "file"
    end
    
    -- Create the markdown link
    local markdownLink = string.format("[%s](%s)", title, path)
    
    -- Copy the markdown link to the unnamed register
    vim.fn.setreg('"', markdownLink)
end

function helpers.CopyFilePathToRegister()
    local path = vim.api.nvim_buf_get_name(0)
    
    -- Copy the file path to the unnamed register
    vim.fn.setreg('"', path)
end


return helpers

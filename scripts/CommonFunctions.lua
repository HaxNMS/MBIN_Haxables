function printf(s, ...)
  print(s:format(...))
end

function checkIsDefined(var, varname)
  if (var ~= nil) then return true end
  printf("ERROR: %s has not been defined.", varname)
  return false
end

function logDebug(msg, ...)
  if HAX_LOGDEBUG == true then
    printf(msg, ...)
  end
end

function showMessageF(msg, ...)
  showMessage(string.format(msg, ...))
end

function logMessage(msg, ...)
  logDebug(msg, ...)
  showMessageF(msg, ...)
end

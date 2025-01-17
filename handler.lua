local kong = kong

local CustomResponsePlugin = {}

-- Constructor
function CustomResponsePlugin:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Header filter phase to hide response headers
function CustomResponsePlugin:header_filter(conf)
  -- Loop through the headers to identify and remove or mask sensitive ones
  for _, header in ipairs(conf.sensitive_headers) do
    local header_value = kong.response.get_header(header)
    if header_value then
      kong.log.debug("Found header to mask: ", header)
      if conf.replacement_text == "[REMOVE]" then
        kong.log.debug("Removing header: ", header)
        kong.response.clear_header(header) -- Remove the header completely
      else
        kong.log.debug("Masking header: ", header, " with value: ", conf.replacement_text)
        kong.response.set_header(header, conf.replacement_text) -- Mask the header value
      end
    end
  end
end

-- Define the plugin priority and version
CustomResponsePlugin.PRIORITY = 10
CustomResponsePlugin.VERSION = "1.0.0"

return CustomResponsePlugin


return {
  name = "custom-response",
  fields = {
    { 
      config = {
        type = "record",
        fields = {
          {
            sensitive_headers = {
              type = "array",
              elements = { type = "string" },
              default = { "Authorization", "X-Api-Key" },
              description = "List of headers to mask in the response."
            }
          },
          {
            replacement_text = {
              type = "string",
              default = "[HIDDEN]",
              description = "Replacement text for sensitive headers."
            }
          },
        },
      },
    },
  },
}

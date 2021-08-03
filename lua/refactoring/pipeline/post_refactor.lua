local Pipeline = require("refactoring.pipeline")
local format = require("refactoring.pipeline.format")
local apply_text_edits = require("refactoring.pipeline.apply_text_edits")

local function create_post_refactor_tasks()
    return Pipeline:from_task(apply_text_edits):add_task(format)
end

return create_post_refactor_tasks


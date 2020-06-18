local _pipe_blit = channel.new("blitter")
if not _pipe_blit then error("Could not create pipeblit")end

_pipe_blit:push(image.data(background.imgData))

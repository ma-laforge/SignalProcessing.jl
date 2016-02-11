#Test code
#-------------------------------------------------------------------------------

#No real test code yet... just run demos:

using FileIO2
using MDDatasets
import MDDatasets: DS
using EasyPlot

#Set default plot backend to matplotlib, if not already specified by user:
#plotlist = Set([:Qwt])
#plotlist = Set([:Grace])
if !isdefined(:plotlist); plotlist = Set([:MPL]); end

#==Define plot rendering function:
===============================================================================#

#Only import EasyPlotGrace (short load time) if desired: 
if in(:Grace, plotlist)
	import EasyPlotGrace

	function DisplayDemoPlot(::DS{:Grace}, plot::EasyPlot.Plot, ncols::Int)
		plotdefaults = GracePlot.defaults(linewidth=2.5)
		gplot = GracePlot.new()
			GracePlot.set(gplot, plotdefaults)
		render(gplot, plot, ncols=ncols); display(gplot)
		return gplot
	end

	function DisplayDemoPlot(ds::DS{:Grace}, plot::EasyPlot.Plot, ncols::Int, outfile)
		gplot = DisplayDemoPlot(ds, plot, ncols)
		if outfile != nothing; save(gplot, outfile); end
	end
end

#Only import EasyPlotMPL (long Python load time) if desired: 
if in(:MPL, plotlist)
	import EasyPlotMPL

	function DisplayDemoPlot(::DS{:MPL}, plot::EasyPlot.Plot, ncols::Int, args...)
		display(:MPL, plot, ncols=ncols);
	end
end

#Only import EasyPlotQwt (long Python load time) if desired: 
if in(:Qwt, plotlist)
	import EasyPlotQwt

	function DisplayDemoPlot(::DS{:Qwt}, plot::EasyPlot.Plot, ncols::Int, args...)
		display(:Qwt, plot, ncols=ncols);
	end
end

function DisplayDemoPlot(plotlist::Set, plot::EasyPlot.Plot, ncols::Int, args...)
	for plottype in plotlist
		DisplayDemoPlot(DS(plottype), plot, ncols, args...)
	end
end


#==Show results
===============================================================================#
for i in 1:17
	file = "../sample/demo$i.jl"
	sepline = "---------------------------------------------------------------------"
	outfile = File(:png, joinpath("./", splitext(basename(file))[1] * ".png"))
	println("\nExecuting $file...")
	println(sepline)
	(plot, ncols) = evalfile(file)
	DisplayDemoPlot(plotlist, plot, ncols)
#	DisplayDemoPlot(plotlist, plot, ncols, outfile)
end


:Test_Complete

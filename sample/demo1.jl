#Demo 1: Pulse generation
#-------------------------------------------------------------------------------

using MDDatasets
using SignalProcessing
using EasyPlot


#==Constants
===============================================================================#
vvst = axes(ylabel="Amplitude (V)", xlabel="Time (s)")
color1 = line(color=:red)
color2 = line(color=:blue)

#==Input data
===============================================================================#
tstart = 0
tstep = .01
tstop = 10

#==Computations
===============================================================================#
t = tstart:tstep:tstop
tDT = DataTime(t)
tCT = DataF1(t)
tmax = maximum(t)
@show len = length(t)
u = step(tDT, ndel=Index(len/4))
p = pulse(tDT, ndel=Index(len/7), npw=Index(len/16))
pulsewidth = tmax/16
u1p = step(tCT, Pole(3/pulsewidth,:rad), tdel=tmax/4)
p1p = pulse(tCT, Pole(3/pulsewidth,:rad), tdel=tmax/7, tpw=pulsewidth)

#==Generate plot
===============================================================================#
plot=EasyPlot.new(title="Generating Simple Responses")
s = add(plot, vvst, title="Step Response")
	add(s, DataF1(u), color1, id="DT")
	add(s, u1p, color2, id="CT")
s = add(plot, vvst, title="Pulse Response")
	add(s, DataF1(p), color1, id="DT")
	add(s, p1p, color2, id="CT")
s = add(plot, vvst, title="Sine wave")
	add(s, sin(tCT*(pi*10/tmax)), color2)

#==Show results
===============================================================================#
PoleRad = SignalProcessing.PoleRad
f(x::Pole) = "Generic pole"
f{T<:Number}(x::PoleRad{T}) = "Pole: $(value(x)) rad!"
phz=Pole(1,:Hz)
prad=Pole(1,:rad)
@show phz, prad
@show value(phz), value(prad)
@show value(:rad,phz), value(:Hz,prad)
@show f(phz), f(prad)

#==Show results
===============================================================================#
ncols = 1
if !isdefined(:plotlist); plotlist = Set([:grace]); end
if in(:grace, plotlist)
	import EasyPlotGrace
	plotdefaults = GracePlot.defaults(linewidth=2.5)
	gplot = GracePlot.new()
		GracePlot.set(gplot, plotdefaults)
	render(gplot, plot, ncols=ncols); display(gplot)
end
if in(:MPL, plotlist)
	import EasyPlotMPL
	display(:MPL, plot, ncols=ncols);
end

:Test_Complete


	.export		_irq, _irq0
	.include        "vt03.inc"
	
.segment       	"STARTUP"

.proc	_irq
	
	rti
.endproc

_irq0:
	rts
	
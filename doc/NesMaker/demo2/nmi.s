	.export		_nmi
	.export		_irq, _irq0
	
	.import		NMIDMACalcLength
	.import		NMIDMAPalette
	.import		NMIDMAScreen
	
	.include        "vt03.inc"
.segment       	"STARTUP"
; ------------------------------------------------------------------------
; System V-Blank Interupt
; ------------------------------------------------------------------------
.proc	_nmi
        rti
.endproc

.proc	_irq
	
	rti
.endproc

_irq0:
	rts

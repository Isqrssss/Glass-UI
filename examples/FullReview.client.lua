-- Revisión de la UI original: crea el panel completo con sus doce pestañas originales y Language al final.
-- Coloca este LocalScript en StarterPlayerScripts después de instalar el ModuleScript.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("ModernLiquidGlassLibrary"))

-- Sin opciones para conservar exactamente los valores visuales predeterminados del script adjunto.
local ui = Library.new()

-- La interfaz ya se crea completa. Este valor queda disponible para cerrar/limpiar desde este script.
_G.ModernLiquidGlassReview = ui

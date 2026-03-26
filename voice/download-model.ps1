# Voice Model Information - Windows PowerShell
# Run: .\voice\download-model.ps1

Write-Host "ℹ️  Voice Model Information" -ForegroundColor Cyan
Write-Host ""
Write-Host "The parakeet-v2 voice model downloads automatically on first voice input."
Write-Host ""
Write-Host "Model details:"
Write-Host "  Name: parakeet-v2"
Write-Host "  Size: ~661MB"
Write-Host "  Location: $env:USERPROFILE\.pi\models\parakeet-v2\"
Write-Host ""
Write-Host "Files:"
Write-Host "  - decoder.int8.onnx (7.3 MB)"
Write-Host "  - encoder.int8.onnx (652 MB)"
Write-Host "  - joiner.int8.onnx (1.7 MB)"
Write-Host "  - tokens.txt (9 KB)"
Write-Host ""
Write-Host "To trigger download:"
Write-Host "  1. Start pi: pi"
Write-Host "  2. Use voice input (default keybinding)"
Write-Host "  3. Model will download automatically"

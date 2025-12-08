echo "starting awa..."
xdg-open http://localhost:5000 &
cd "$HOME/programming/web/awa-frontend" && pnpm start --port 5000 
sleep 2 



let image = document.querySelector('#images');

if (image){
    fetch('/uploads/')
        .then(res => res.json())
        .then(res => {
            res.forEach(image => {
                const img = document.createElement('img');
                img.src = `/uploads/${image}`
                picture.appendChild(img)
            });
        })
}
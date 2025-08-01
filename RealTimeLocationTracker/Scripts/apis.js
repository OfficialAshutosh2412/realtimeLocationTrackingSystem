﻿// my location history for user
function FetchMyLocationHistory(username) {
    fetch(`GetUserPath.aspx?username=${encodeURIComponent(username)}`)
        .then((res) => res.json())
        .then((data) => {
            const latlong = data.map(items => [items.latitude, items.longitude])
            L.polyline(latlong, {
                color: 'blue',
                weight: 3
            }).addTo(map);
            map.fitBounds(latlong);

            //now make markers
            data.forEach((point, index) => {
                //checking each element is last or not, for that, i am comparing upcomming index with last index, index whch match the last index will be the last element with last index and isLast becomes true.
                const isLast = index === data.length - 1;
                //setting color green for dots, by default
                let color = 'red';
                //setting color red, if element is last, otherwise rest ae green dots
                if (isLast) {
                    color = point.isOnline ? 'green' : 'red';
                }
                //markers for creating dot on location
                L.circleMarker([point.latitude, point.longitude], {
                    radius: isLast ? 8 : 5,
                    color: color,
                    fillColor: color,
                    fillOpacity: 0.9
                }).addTo(map).bindPopup(`
                            <b>${point.username}</b><br>
                            ${isLast ? (point.isOnline ? "🟢 Online" : "🔴 offline") : "🔴 offline"}<br>
                            
                            <small>${point.recordedAt}</small>
                        `);
            });
        })
}

//online user's api call
function fetchData(username) {
    fetch(`../Shared Endpoint/CurrentLocationEndPoint.aspx?username=${encodeURIComponent(username)}`)
        .then((res) => res.json())
        .then((data) => {
            const latlong = data.map(items => [items.latitude, items.longitude])
            L.polyline(latlong, {
                color: 'blue',
                weight: 3
            }).addTo(map);
            map.fitBounds(latlong);

            data.forEach((point, index) => {
                const isLast = index === data.length - 1;
                let color = isLast ? 'purple' : 'green';
                const marker = L.circleMarker([point.latitude, point.longitude], {
                    radius: isLast ? 8 : 5,
                    color: color,
                    fillColor: color,
                    fillOpacity: 0.9
                }).addTo(map);
                marker.bindPopup(`
                            <b>${point.username}</b><br>
                            ${isLast ? (point.isOnline ? "🟣 Online" : "🔴 offline") : "🟢 previously online"}<br>
                            <small>${point.recordedAt}</small>
                        `);

                // Add permanent tooltip only on the last (latest) point
                if (isLast) {
                    marker.bindTooltip("Currently here", {
                        permanent: true,
                        direction: "top",
                        className: "current-tooltip"
                    }).openTooltip();
                }
            })
        })
}

//location history of all user for admin
function LoadMapData() {
    fetch('GetAllUserLocationHistory.aspx')
        .then(res => res.json())
        .then(data => {
            //creating empty object group
            const group = {};
            //going through all rows, and check if there i a group with username key then skip or init a new key with username as an empty array. And then push the row that has same username in their username group.
            data.forEach(item => {
                if (!group[item.username]) {
                    group[item.username] = [];
                }
                group[item.username].push(item);
            })
            //now we get the groups, now loop through every keys, to get the keys, and with the of those keys, you have to loop through groups[keys] to get each group data of each key, then extract latitude, longitude in an array, so this way you are creating an array or arrays for polylines.
            Object.keys(group).forEach((username, index) => {
                const points = group[username];
                const paths = points.map(p => [p.latitude, p.longitude])
                //now draw pollylines
                L.polyline(paths, {
                    color: 'blue', weight: 3,
                }).addTo(map);
                map.fitBounds(paths);
                //points have an array of usernames, which have values of their location history.
                //when loop on it, we get p as their values and index as curent index, we compared current index with the last index, if they are equal then w got the last element or index number.
                //then we checked, if it is the last element and it contains isOnline as true, if both are tru then we made color green, which is bydefault set red.
                points.forEach((p, index) => {
                    const isLast = index === points.length - 1;
                    let color = 'red';
                    if (isLast && p.isOnline) {
                        color = 'green';
                    }
                    //now we are making dots.
                    L.circleMarker([p.latitude, p.longitude], {
                        radius: 6,
                        color: color,
                        fillColor: color,
                        fillOpacity: 0.9
                    }).addTo(map).bindPopup(`
                                ${p.username}<br/>
                                <small>${isLast ? (p.isOnline ? "🟢 Online" : "🔴 Offline") : "🔴 Offline"}</small><br/>
                                <small>${p.recordedAt}</small>
                            `);
                });
            })

        })
}


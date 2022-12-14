/*
no switches?
⠀⣞⢽⢪⢣⢣⢣⢫⡺⡵⣝⡮⣗⢷⢽⢽⢽⣮⡷⡽⣜⣜⢮⢺⣜⢷⢽⢝⡽⣝
 ⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇ 
⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀
 ⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀
 ⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀
 ⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 ⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋
*/

void getIntegratedSpecular(inout vec4 albedo, in vec3 normal, in vec2 worldPos, in vec2 lightmap, inout float specular) {
    float lAlbedo = length(albedo.rgb);

    if (mat == 300) {// Sand
        specular = int(albedo.b > 0.65 || albedo.b > 0.7) * 0.125;
    } else if (mat == 301) {// Iron Block
        specular = int(pow16(albedo.r)) * 16.0;
    } else if (mat == 302) {// Gold Block & Gold Pressure Plate & Amethyst
        specular = pow8(clamp(lAlbedo, 0.0, 1.0));
    } else if (mat == 303) {// Emerald & Diamond Blocks
        specular = pow12(lAlbedo);
    } else if (mat == 304 || mat == 306) {// Polished Stones Blocks & Basalt & Prismarine (my previous shader really)
        specular = pow4(clamp(lAlbedo, 0.0, 1.0)) * 0.15;
    } else if (mat == 305) {// Obsidian & Polished Deepslate
        specular = lAlbedo * 0.2;
    }

    #if defined RAIN_PUDDLES && defined GBUFFERS_TERRAIN
    float NoU = clamp(dot(normal, upVec), 0.0, 1.0);
    float puddles = wetness * pow8(lightmap.y) * (texture2D(noisetex, (worldPos + cameraPosition.xz) * 0.00125).b - 0.5) * NoU;

    if (puddles > 0.0) {
        albedo.rgb *= 1.0 - puddles * 0.25;
        specular += puddles * 0.5;
    }
    #endif

    specular = clamp(specular * SPECULAR_STRENGTH, 0.0, 0.99);
}